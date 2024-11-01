{
  lib,
  config,
  moduleLocation,
  ...
}: let
  inherit
    (lib)
    mkOption
    types
    ;

  modulesFromDirectoryRecursive = {
    directory,
    includeDefaults,
  }: let
    entries = builtins.readDir directory;

    # Get all .nix files in a directory (excluding default.nix)
    getNixFiles = dir: let
      files = builtins.attrNames (builtins.readDir dir);
      nixFiles = builtins.filter (n: n != "default.nix" && lib.hasSuffix ".nix" n) files;
      moduleNames = map (file: lib.removeSuffix ".nix" file) nixFiles;
    in {
      inherit moduleNames;
      modules = builtins.listToAttrs (map (name: {
          inherit name;
          value = {
            _file = "${toString moduleLocation}#nixosModules.${name}";
            imports = [(import (dir + "/${name}.nix"))];
          };
        })
        moduleNames);
    };

    processEntry = name: type: let
      path = directory + "/${name}";
      baseName = lib.removeSuffix ".nix" name;
    in
      if type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix"
      then
        lib.nameValuePair
        baseName
        {
          _file = "${toString moduleLocation}#nixosModules.${baseName}";
          imports = [(import path)];
        }
      else if type == "directory"
      then let
        defaultPath = path + "/default.nix";
        hasDefault = builtins.pathExists defaultPath;
        dirModules =
          if hasDefault
          then let
            # If directory has a default.nix, first get all other modules
            dirFiles = getNixFiles path;
            # Then import default.nix
            defaultModule = import defaultPath;
            # If default.nix defines its own modules, use those
            # Otherwise, create a default that imports all modules in the directory (if enabled)
            moduleSet =
              if builtins.isAttrs defaultModule && defaultModule ? flake.nixosModules
              then defaultModule.flake.nixosModules
              else if includeDefaults
              then
                dirFiles.modules
                // {
                  default = {
                    _file = "${toString moduleLocation}#nixosModules.${name}.default";
                    imports = builtins.attrValues dirFiles.modules;
                  };
                }
              else dirFiles.modules;
          in
            moduleSet
          else
            modulesFromDirectoryRecursive {
              directory = path;
              inherit includeDefaults;
            };
      in
        lib.nameValuePair name dirModules
      else lib.nameValuePair "" {};

    processed = lib.mapAttrsToList processEntry entries;
    modules = lib.filterAttrs (n: _: n != "") (lib.listToAttrs processed);

    # Add default module at the root level if includeDefaults is true
    rootDefaultPath = directory + "/default.nix";
    hasRootDefault = builtins.pathExists rootDefaultPath;
    rootDefaultModule =
      if hasRootDefault
      then import rootDefaultPath
      else null;
  in
    if hasRootDefault && builtins.isAttrs rootDefaultModule && rootDefaultModule ? flake.nixosModules
    then rootDefaultModule.flake.nixosModules
    else if includeDefaults
    then
      modules
      // {
        default = {
          _file = "${toString moduleLocation}#nixosModules.default";
          imports = builtins.attrValues modules;
        };
      }
    else modules;
in {
  options = {
    auto = mkOption {
      type = types.submodule {
        options = {
          nixosModules = {
            enable = mkOption {
              type = types.bool;
              default = true;
              description = "Whether to enable automatic NixOS module discovery.";
            };

            path = mkOption {
              type = types.nullOr types.path;
              default = ./modules;
              description = "The directory to scan for NixOS modules.";
            };

            includeDefaults = mkOption {
              type = types.bool;
              default = true;
              description = ''
                Whether to automatically create default modules that aggregate all modules in a directory.
                When false, directories with default.nix files that don't define flake.nixosModules will only export their individual modules.
                When true, such directories will also get a default module that imports all other modules.
              '';
            };
          };
        };
      };
      default = {};
      description = "Automatic flake output generation options.";
    };
  };

  config = {
    flake.nixosModules =
      lib.mkIf (config.auto.nixosModules.enable && config.auto.nixosModules.path != null)
      (modulesFromDirectoryRecursive {
        directory = config.auto.nixosModules.path;
        inherit (config.auto.nixosModules) includeDefaults;
      });
  };
}
