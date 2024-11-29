{
  perSystem = {
    self',
    pkgs,
    lib,
    system,
    ...
  }: let
    inherit (pkgs) callPackage python312Packages;
  in {
    packages = lib.flakes.platformPkgs system {
      # by-name / ac
      actual-server = callPackage ./by-name/ac/actual-server {};

      # by-name / bu
      # buildarr = python311Packages.callPackage ./by-name/bu/buildarr {};

      # by-name / ch
      chartify = callPackage ./by-name/ch/chartify {};
      charts-syncer = callPackage ./by-name/ch/charts-syncer {};

      # by-name / cu
      cueimports = callPackage ./by-name/cu/cueimports {};

      # by-name / cu
      ersatztv = callPackage ./by-name/er/ersatztv {};

      # by-name / he
      helm-dt = callPackage ./by-name/he/helm-dt {};
      helm-images = callPackage ./by-name/he/helm-images {};
      helm-schema = callPackage ./by-name/he/helm-schema {};

      # by-name / im
      imgpkg = callPackage ./by-name/im/imgpkg {};

      # by-name / je
      jetbrains-fleet = callPackage ./by-name/je/jetbrains-fleet {};

      # by-name / kc
      kbld = callPackage ./by-name/kb/kbld {};

      # by-name / kc
      kcl-language-server = callPackage ./by-name/kc/kcl-language-server {};

      # by-name / ku
      kubectl-kcl = callPackage ./by-name/ku/kubectl-kcl {};
      kusion = callPackage ./by-name/ku/kusion {};
      kustomizer = callPackage ./by-name/ku/kustomizer {};

      # by-name / mk
      mkdocs-exec = python312Packages.callPackage ./by-name/mk/mkdocs-exec {};
      mkdocs-git-authors-plugin = python312Packages.callPackage ./by-name/mk/mkdocs-git-authors-plugin {};

      # by-name / os
      ospeak = callPackage ./by-name/os/ospeak {};

      # by-name / p1
      p12 = callPackage ./by-name/p1/p12 {};

      # by-name / sr
      strip-tags = python312Packages.callPackage ./by-name/sr/strip-tags {};

      # by-name / zo
      zot = callPackage ./by-name/zo/zot {};
    };

    apps = lib.mapAttrs (_name: drv: lib.flakes.mkApp {inherit drv;}) self'.packages;

    overlayAttrs = self'.packages;
  };
}
