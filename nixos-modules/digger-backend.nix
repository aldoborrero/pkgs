{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.digger;
in {
  options.services.digger = {
    enable = mkEnableOption "Digger";

    package = mkPackageOption pkgs "digger-backend" {};

    user = mkOption {
      type = types.str;
      default = "digger";
      description = "User account under which Digger runs.";
    };

    group = mkOption {
      type = types.str;
      default = "digger";
      description = "Group under which Digger runs.";
    };

    settings = mkOption {
      type = types.attrs;
      default = {};
      example = literalExpression ''
        {
          GITHUB_ORG = "myorg";
          HOSTNAME = "digger.example.com";
          HTTP_BASIC_AUTH = "1";
          HTTP_BASIC_AUTH_USERNAME = "myorg";
          ALLOW_DIRTY = "false";
          GITHUB_APP_ID = "123";
          GITHUB_APP_CLIENT_ID = "abc";
        }
      '';
      description = "Environment variables for configuring Digger server";
    };

    credentialsFile = mkOption {
      type = types.path;
      description = ''
        Path to file containing sensitive credentials.
        This file should contain environment variables with secrets.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 3000;
      description = "Port on which Digger server listens";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to automatically open the specified port in the firewall";
    };

    stateDir = mkOption {
      type = types.path;
      default = "/var/lib/digger";
      description = "State directory for Digger data";
    };

    postgresql = {
      socketPath = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Path to PostgreSQL unix socket if using socket authentication";
      };
    };
  };

  config = mkIf cfg.enable {
    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [cfg.port];
    };

    systemd.services.digger-server = {
      description = "Digger";
      after = ["network.target" "postgresql.service"];
      wantedBy = ["multi-user.target"];

      environment =
        {
          PORT = cfg.port;
        }
        // cfg.settings;

      serviceConfig = {
        Type = "simple";
        ExecStart = getExe cfg.package;
        DynamicUser = true;
        User = cfg.user;
        Group = cfg.group;
        Restart = "on-failure";
        WorkingDirectory = cfg.stateDir;

        EnvironmentFile = optional (cfg.environmentFile != null) cfg.credentialsFile;

        # Hardening options
        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = false; # Disabled for PostgreSQL authentication
        ProtectSystem = "full";
        RemoveIPC = false; # Disabled for PostgreSQL communication
        RestrictAddressFamilies = ["AF_INET" "AF_INET6" "AF_UNIX"];
        UMask = "0077";

        # Allow writing to state directory
        ReadWritePaths =
          [cfg.stateDir]
          ++ optional (cfg.postgresql.socketPath != null) cfg.postgresql.socketPath;
      };
    };

    users.users = mkIf (cfg.user == "digger") {
      ersatztv = {
        inherit (cfg) group;
        isSystemUser = true;
      };
    };

    users.groups = mkIf (cfg.group == "digger") {digger = {};};
  };
}
