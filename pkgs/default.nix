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

      # by-name / fi
      filebrowser = callPackage ./by-name/fi/filebrowser {};

      # by-name / je
      jetbrains-fleet = callPackage ./by-name/je/jetbrains-fleet {};

      # by-name / ll
      llm = callPackage ./by-name/ll/llm {};

      # by-name / ol
      ollama-webui = python311Packages.callPackage ./by-name/ol/ollama-webui {};

      # by-name / ot
      oterm = python311Packages.callPackage ./by-name/ot/oterm {};

      # by-name / os
      ospeak = callPackage ./by-name/os/ospeak {
        inherit openai; # requires openai version 1.0
      };

      # by-name / sr
      strip-tags = python311Packages.callPackage ./by-name/sr/strip-tags {};

      # by-name / sy
      systemctl-tui = callPackage ./by-name/sy/systemctl-tui {};

      # development / python-modules

      # llm-claude = python311Packages.callPackage ./development/python-modules/llm-claude {inherit llm;};
      # llm-gpt4all = python311Packages.callPackage ./development/python-modules/llm-gpt4all {inherit llm;};

      ctransformers = python311Packages.callPackage ./development/python-modules/ctransformers {};
      essentials = python311Packages.callPackage ./development/python-modules/essentials {};
      essentials-openapi = python311Packages.callPackage ./development/python-modules/essentials-openapi {inherit essentials;};
      gpt4all = python311Packages.callPackage ./development/python-modules/gpt4all {};
      llm-clip = python311Packages.callPackage ./development/python-modules/llm-clip {inherit llm;};
      llm-cluster = python311Packages.callPackage ./development/python-modules/llm-cluster {inherit llm;};
      llm-llama-cpp = python311Packages.callPackage ./development/python-modules/llm-llama-cpp {inherit llm;};
      llm-mlc = python311Packages.callPackage ./development/python-modules/llm-mlc {inherit llm;};
      llm-mpt30b = python311Packages.callPackage ./development/python-modules/llm-mpt30b {inherit llm ctransformers;};
      llm-sentence-transformers = python311Packages.callPackage ./development/python-modules/llm-sentence-transformers {inherit llm;};
      mkdocs-git-authors-plugin = callPackage ./development/python-modules/mkdocs-git-authors-plugin {};
      mkdocs-plugins = callPackage ./development/python-modules/mkdocs-plugins {inherit essentials-openapi;};
      mlc-llm = python311Packages.callPackage ./development/python-modules/mlc-llm {};
      openai = python311Packages.callPackage ./development/python-modules/openai {};
      pydanticv2 = python311Packages.callPackage ./development/python-modules/pydanticv2 {};
      pyemvue = python311Packages.callPackage ./development/python-modules/pyemvue {};
    };

    apps = lib.mapAttrs (_name: drv: lib.flakes.mkApp {inherit drv;}) self'.packages;

    overlayAttrs = self'.packages;
  };
}
