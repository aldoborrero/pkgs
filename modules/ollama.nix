{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.services.ollama;
in {
  options.services.ollama = {
    enable = mkEnableOption "Ollama Server";

    package = mkOption {
      type = types.package;
      default = pkgs.ollama;
      description = "The Ollama package to use.";
    };

    host = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = "Host for Ollama Server.";
    };

    port = mkOption {
      type = types.str;
      default = "11434";
      description = "Port for Ollama Server.";
    };

    origins = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Origins for Ollama Server.";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.ollama = {
      description = "Ollama Server";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      StateDirectory = "ollama";
      DynamicUser = true;
      serviceConfig = {
        execStart = "${cfg.package}/bin/ollama serve";
        Restart = "always";
        Environment = [
          "OLLAMA_HOST=${cfg.host}:${cfg.port}"
          "OLLAMA_ORIGINS=${concatStringsSep "," cfg.origins}"
        ];
      };
    };
  };
}
