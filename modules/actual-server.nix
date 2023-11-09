{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.services.actual-server;
in {
  options.services.actual-server = {
    enable = lib.mkEnableOption "Actual Server";

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
      description = "Hostname for the Actual Server.";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 4000;
      description = "Port on which the Actual Server should listen.";
    };

    userFiles = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/actual-server";
      description = "Directory for user files.";
    };

    upload = {
      fileSizeSyncLimitMB = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        description = "File size limit in MB for synchronized files.";
      };

      syncEncryptedFileSizeLimitMB = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        description = "File size limit in MB for synchronized encrypted files.";
      };

      fileSizeLimitMB = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        description = "File size limit in MB for file uploads.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [pkgs.actual-server];

    systemd.services.actual-server = {
      description = "Actual Server";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      StateDirectory = "actual-server";
      DynamicUser = true;
      serviceConfig = {
        ExecStart = "${pkgs.actual-server}/bin/start-actual-server";
        Restart = "always";
      };
      environment = {
        # Set environment variables from configuration options here
        ACTUAL_HOSTNAME = cfg.hostname;
        ACTUAL_PORT = toString cfg.port;
        ACTUAL_USER_FILES = cfg.userFiles;
        # For uploads, set the respective environment variables.
        ACTUAL_UPLOAD_FILE_SYNC_SIZE_LIMIT_MB = toString (cfg.upload.fileSizeSyncLimitMB or "");
        ACTUAL_UPLOAD_SYNC_ENCRYPTED_FILE_SIZE_LIMIT_MB = toString (cfg.upload.syncEncryptedFileSizeLimitMB or "");
        ACTUAL_UPLOAD_FILE_SIZE_LIMIT_MB = toString (cfg.upload.fileSizeLimitMB or "");
      };
    };
  };
}
