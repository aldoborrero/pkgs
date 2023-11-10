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
      # by-name / ac
      actual-server = callPackage ./by-name/ac/actual-server {};

      # by-name / fi
      filebrowser = callPackage ./by-name/fi/filebrowser {};

      # by-name / je
      jetbrains-fleet = callPackage ./by-name/je/jetbrains-fleet {};

      # by-name / ll
      llm = callPackage ./by-name/ll/llm {};

      # by-name / os
      ospeak = callPackage ./by-name/os/ospeak {
        inherit openai; # requires openai version 1.0
      };

      # by-name / sr
      strip-tags = python311Packages.callPackage ./by-name/sr/strip-tags {};

      # by-name / sy
      systemctl-tui = callPackage ./by-name/sy/systemctl-tui {};

      # development / python-modules
      ctransformers = python311Packages.callPackage ./development/python-modules/ctransformers {};
      llm-clip = python311Packages.callPackage ./development/python-modules/llm-clip {inherit llm;};
      llm-cluster = python311Packages.callPackage ./development/python-modules/llm-cluster {inherit llm;};
      llm-gpt4all = python311Packages.callPackage ./development/python-modules/llm-gpt4all {inherit llm;};
      llm-llama-cpp = python311Packages.callPackage ./development/python-modules/llm-llama-cpp {inherit llm;};
      llm-mlc = python311Packages.callPackage ./development/python-modules/llm-mlc {inherit llm;};
      llm-mpt30b = python311Packages.callPackage ./development/python-modules/llm-mpt30b {inherit llm ctransformers;};
      llm-sentence-transformers = python311Packages.callPackage ./development/python-modules/llm-sentence-transformers {inherit llm;};
      openai = python311Packages.callPackage ./development/python-modules/openai {};
      pyemvue = callPackage ./development/python-modules/pyemvue {};
    };

    apps = lib.mapAttrs (_name: drv: lib.flakes.mkApp {inherit drv;}) self'.packages;

    overlayAttrs = self'.packages;
  };
}
