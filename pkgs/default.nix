{
  perSystem = {
    self',
    pkgs,
    lib,
    system,
    ...
  }: let
    inherit (pkgs) callPackage python311Packages;
  in {
    packages = lib.flakes.platformPkgs system rec {
      # by-name / ac
      actual-server = callPackage ./by-name/ac/actual-server {};

      # by-name / bu
      # buildarr = python311Packages.callPackage ./by-name/bu/buildarr {};


      # by-name / cu
      cueimports = callPackage ./by-name/cu/cueimports {};

      # by-name / dt
      dt = callPackage ./by-name/dt/distribution-tooling-for-helm {};

      # by-name / he
      helm-images = callPackage ./by-name/he/helm-images {};
      helm-schema = callPackage ./by-name/he/helm-schema {};

      # by-name / im
      imgpkg = callPackage ./by-name/im/imgpkg {};

      # by-name / je
      jetbrains-fleet = callPackage ./by-name/je/jetbrains-fleet {};

      # by-name / kc
      kbld = callPackage ./by-name/kb/kbld {};

      # by-name / kc
      kcl = callPackage ./by-name/kc/kcl {inherit kclvm kclvm_cli;};
      kcl-language-server = callPackage ./by-name/kc/kcl-language-server {};
      kclvm = callPackage ./by-name/kc/kclvm {};
      kclvm_cli = callPackage ./by-name/kc/kclvm_cli {inherit kclvm;};

      # by-name / ku
      kusion = callPackage ./by-name/ku/kusion {};

      # by-name / ll
      llm = callPackage ./by-name/ll/llm {};

      # by-name / os
      ospeak = callPackage ./by-name/os/ospeak {};

      # by-name / sr
      strip-tags = python311Packages.callPackage ./by-name/sr/strip-tags {};

      # by-name / zo
      zot = callPackage ./by-name/zo/zot {};

      # development / python-modules

      ctransformers = python311Packages.callPackage ./development/python-modules/ctransformers {};
      gpt4all = python311Packages.callPackage ./development/python-modules/gpt4all {};
      mkdocs-exec = python311Packages.callPackage ./development/python-modules/mkdocs-exec {};
      mkdocs-git-authors-plugin = python311Packages.callPackage ./development/python-modules/mkdocs-git-authors-plugin {};
      mlc-llm = python311Packages.callPackage ./development/python-modules/mlc-llm {};
    };

    apps = lib.mapAttrs (_name: drv: lib.flakes.mkApp {inherit drv;}) self'.packages;

    overlayAttrs = self'.packages;
  };
}
