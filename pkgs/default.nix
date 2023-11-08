{
  perSystem = {
    self',
    pkgs,
    lib,
    ...
  }: {
    packages = let
      inherit (pkgs) callPackage python311Packages;
    in rec {
      # by-name / fi
      filebrowser = callPackage ./by-name/fi/filebrowser {};

      # by-name / je
      jetbrains-fleet = callPackage ./by-name/je/jetbrains-fleet {};

      # by-name/ os
      ospeak = callPackage ./by-name/os/ospeak {
        inherit openai; # requires openai version 1.0
      };

      # by-name / sy
      systemctl-tui = callPackage ./by-name/sy/systemctl-tui {};

      # by-name / ll
      llm = callPackage ./by-name/ll/llm {};

      # development / python-modules
      pyemvue = callPackage ./development/python-modules/pyemvue {};
      openai = python311Packages.callPackage ./development/python-modules/openai {};
    };

    apps = builtins.mapAttrs (_name: drv: lib.flakes.mkApp {inherit drv;}) self'.packages;

    overlayAttrs = self'.packages;
  };
}
