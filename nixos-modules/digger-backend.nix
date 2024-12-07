{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.digger-backend;
in {
  options.services.digger-backend = {
    enable = mkEnableOption "Digger backend service";

    package = mkPackageOption pkgs "digger-backend" {};

    settings = mkOption {
      type = types.attrs;
      default = {};
      example = literalExpression ''
        {
          GITHUB_ORG = "myorg";
          HOSTNAME = "digger.example.com";
          PORT = "3000";
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
      default = "/var/lib/digger-server";
      description = "State directory for Digger server data";
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
      description = "Digger Server Service";
      wantedBy = ["multi-user.target"];
      after = ["network.target" "postgresql.service"];

      environment = cfg.settings;

      serviceConfig =
        {
          Type = "simple";
          ExecStart = getExe cfg.package;
          Restart = "always";
          RestartSec = "10";
          StateDirectory = baseNameOf cfg.stateDir;
          WorkingDirectory = cfg.stateDir;
          DynamicUser = true;

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
        }
        // optionalAttrs (cfg.credentialsFile != null) {
          EnvironmentFile = [cfg.credentialsFile];
        };
    };
  };
}
