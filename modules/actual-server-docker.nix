{
  config,
  lib,
  ...
}: let
  cfg = config.services.actual-server;
in {
  options.services.actual-server = {
    enable = lib.mkEnableOption "Actual Server";

    image = lib.mkOption {
      type = lib.types.str;
      default = "docker.io/actualbudget/actual-server:24.9.0-alpine";
      description = "Docker image to use for Actual Server";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 5006;
      description = "Port on which the Actual Server should listen";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/actual-server";
      description = "Directory for Actual Server data";
    };

    httpsKey = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Path to HTTPS key file";
    };

    httpsCert = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Path to HTTPS certificate file";
    };

    upload = {
      fileSyncSizeLimitMB = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        description = "File size limit in MB for synchronized files";
      };

      syncEncryptedFileSizeLimitMB = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        description = "File size limit in MB for synchronized encrypted files";
      };

      fileSizeLimitMB = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        description = "File size limit in MB for file uploads";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.podman.enable = true;
    virtualisation.oci-containers.backend = "podman";

    virtualisation.oci-containers.containers.actual-server = {
      image = cfg.image;
      ports = ["${toString cfg.port}:5006"];
      volumes = [
        "${cfg.dataDir}:/data"
      ];
      environment = lib.filterAttrs (_n: v: v != null) {
        ACTUAL_PORT = toString cfg.port;
        ACTUAL_HTTPS_KEY = cfg.httpsKey;
        ACTUAL_HTTPS_CERT = cfg.httpsCert;
        ACTUAL_UPLOAD_FILE_SYNC_SIZE_LIMIT_MB = toString (cfg.upload.fileSyncSizeLimitMB or "");
        ACTUAL_UPLOAD_SYNC_ENCRYPTED_FILE_SYNC_SIZE_LIMIT_MB = toString (cfg.upload.syncEncryptedFileSizeLimitMB or "");
        ACTUAL_UPLOAD_FILE_SIZE_LIMIT_MB = toString (cfg.upload.fileSizeLimitMB or "");
      };
    };

    systemd.services.podman-actual-server = {
      description = "Actual Server Container";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Restart = "unless-stopped";
      };
    };

    # Ensure the data directory exists
    system.activationScripts.actual-server-data-dir = ''
      mkdir -p ${cfg.dataDir}
    '';
  };
}
