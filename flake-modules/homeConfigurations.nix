{
  lib,
  config,
  flake-parts-lib,
  ...
}:
with lib; {
  options.perSystem = flake-parts-lib.mkPerSystemOption {
    _file = ./homeConfigurations.nix;
    options.homeConfigurations = mkOption {
      description = mdDoc ''
        An attribute set containing Home Manager configurations, keyed by the username or identifier.
        These configurations will be merged into the final flake outputs.
      '';
      type = types.lazyAttrsOf types.unspecified;
      default = {};
      example = literalExpression ''
        {
          "alice@host" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            modules = [ ./home.nix ];
          };
        }
      '';
      visible = true;
    };
  };

  config = {
    assertions = [
      {
        assertion =
          builtins.all (conf: conf ? pkgs || conf ? extraSpecialArgs)
          (builtins.attrValues config.flake.homeConfigurations);
        message = "All Home Manager configurations must have either 'pkgs' or 'extraSpecialArgs' defined";
      }
    ];

    flake.homeConfigurations =
      lib.mergeAttrsList
      (attrValues (genAttrs config.systems (
        system:
          config.allSystems.${system}.homeConfigurations
      )));
  };
}
