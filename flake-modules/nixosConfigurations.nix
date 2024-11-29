{
  config,
  flake-parts-lib,
  lib,
  ...
}: let
  inherit (config) systems allSystems;
in {
  options.perSystem = flake-parts-lib.mkPerSystemOption {
    _file = ./nixosConfigurations.nix;
    options.nixosConfigurations = lib.mkOption {
      description = "An attribute set containing NixOS system configurations, keyed by the target system.";
      type = lib.types.lazyAttrsOf lib.types.unspecified;
      default = {};
    };
  };

  config.flake.nixosConfigurations =
    builtins.foldl'
    (x: y: x // y) {}
    (lib.attrValues (lib.genAttrs systems (system: allSystems.${system}.nixosConfigurations)));
}
