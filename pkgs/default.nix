{
  perSystem = {
    self',
    pkgs,
    lib,
    ...
  }: {
    packages = let
      scope = lib.makeScope pkgs.newScope (
        _self:
          lib.pipe (lib.packagesFromDirectoryRecursive {
            inherit (pkgs) callPackage;
            directory = ./by-name;
          }) [
            (lib.collect lib.isDerivation)
            (map (x: lib.nameValuePair (builtins.head (builtins.split "-[0-9].*$" x.name)) x))
            builtins.listToAttrs
          ]
      );
    in
      scope.overrideScope (_final: _prev: {});

    overlayAttrs = self'.packages;
  };
}
