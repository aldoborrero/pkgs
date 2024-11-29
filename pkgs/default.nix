{
  perSystem = {
    self',
    pkgs,
    lib,
    ...
  }: {
    packages =
      lib.pipe (lib.packagesFromDirectoryRecursive {
        inherit (pkgs) callPackage;
        directory = ./by-name;
      }) [
        (lib.collect lib.isDerivation)
        (map (x: lib.nameValuePair (builtins.head (builtins.split "-[0-9].*$" x.name)) x))
        builtins.listToAttrs
      ];

    overlayAttrs = self'.packages;
  };
}
