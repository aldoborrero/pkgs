{
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkOption types;

  flattenAttrs = {
    attrs ? {},
    separator ? "/",
    callback,
  }: let
    flatten = attrSet: prefixes:
      builtins.foldl' (
        acc: name: let
          newValue = attrSet.${name};
          newKey = prefixes ++ [name];
        in
          if lib.isFunction newValue
          then acc // {${lib.concatStringsSep separator newKey} = newValue callback;}
          else acc // (flatten newValue newKey)
      ) {} (builtins.attrNames attrSet);
  in
    flatten attrs [];
in {
  options = {
    auto = {
      pkgs = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Whether to enable automatic package discovery.";
        };

        path = mkOption {
          type = types.nullOr types.path;
          default = ./pkgs;
          description = "The directory to scan for packages.";
        };

        separator = mkOption {
          type = types.str;
          default = "/";
          description = "The separator to use when flattening package names.";
        };
      };
    };
  };

  config = {
    perSystem = {
      config,
      pkgs,
      ...
    }: let
      cfg = config.auto.pkgs;

      scope = lib.makeScope pkgs.newScope (_self: {
        inherit inputs;
      });
    in
      lib.mkIf (cfg.enable && cfg.path != null) {
        legacyPackages = lib.filesystem.packagesFromDirectoryRecursive {
          directory = cfg.path;
          inherit (scope) callPackage;
        };

        packages = flattenAttrs {
          attrs = lib.filesystem.packagesFromDirectoryRecursive {
            directory = cfg.path;
            callPackage = file: args: callback:
              callback file args;
          };
          inherit (cfg) separator;
          callback = scope.callPackage;
        };
      };
  };
}
