{
  flake.nixosModules = let
    # Get all .nix files in the current directory
    files = builtins.attrNames (builtins.readDir ./.);

    # Filter out any non-.nix files
    nixFiles = builtins.filter (n: builtins.match ".*\\.nix" n != null) files;

    # Remove the .nix extension
    moduleNames = map (file: builtins.elemAt (builtins.split "\\." file) 0) nixFiles;

    # Create an attribute set of module name to file path
    modules = builtins.listToAttrs (map (name: {
        inherit name;
        value = import (./. + "/${name}.nix");
      })
      moduleNames);
  in
    # Add a 'default' module that imports all other modules
    modules
    // {
      default = {imports = builtins.attrValues modules;};
    };
}
