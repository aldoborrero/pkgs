{config, pkgs, lib, ...} : let
  cfg = config.services.ollama;
in {
  options.services.ollama = {
    enable = lib.mkEnableOption "Ollama Server";
  };

  config = lib.mkIf cfg.enable {
    systemd.services.ollama = {
      description = "Ollama Server";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      StateDirectory = "ollama";
      DynamicUser = true;
      serviceConfig = {
        execStart = "${pkgs.ollama}/bin/ollama serve";
        Restart = "always";
      };
    };
  };
}
