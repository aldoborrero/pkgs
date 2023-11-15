{
  buildPythonPackage,
  cmake,
  fetchFromGitHub,
  lib,
  pkg-config,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
  stdenv,
  tqdm,
  vulkan-headers,
  vulkan-loader,
  vulkan-tools,
  shaderc,
}: let
  pname = "gpt4all";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "nomic-ai";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-G8KHLsnR75iukPJ2GypX3QHafDOLuXyC1wxyQzx28q4=";
    fetchSubmodules = true;
  };

  gpt4all-backend = stdenv.mkDerivation {
    inherit version src;
    pname = "${pname}-backend";

    nativeBuildInputs = [
      cmake
      pkg-config
      shaderc
      vulkan-headers
      vulkan-loader
      vulkan-tools
    ];

    dontUseCmakeConfigure = true;

    buildPhase = ''
      cd gpt4all-backend
      mkdir build
      cd build
      cmake ..
      cmake --build . --parallel
    '';
  };
in
  buildPythonPackage rec {
    pname = "gpt4all";
    version = "2.5.2";
    pyproject = true;

    disabled = pythonOlder "3.8";

    inherit src;
    sourceRoot = "source/gpt4all-bindings/python";

    postUnpack = ''
      chmod -R +w $sourceRoot/gpt4all
    '';

    dontUseCmakeConfigure = true;

    nativeBuildInputs = [
      setuptools
      gpt4all-backend
      cmake
    ];

    propagatedBuildInputs = [
      requests
      tqdm
    ];

    nativeCheckInputs = [
      pytestCheckHook
    ];

    # Fix tests by preventing them from writing to /homeless-shelter.
    # preCheck = "export HOME=$(mktemp -d)";

    # Tests are performed against HuggingFace downloading extra models
    doCheck = true;

    pythonImportsCheck = [
      "gpt4all"
    ];

    meta = with lib; {
      homepage = "https://github.com/nomic-ai/gpt4all";
      description = "gpt4all: open-source LLM chatbots that you can run anywhere";
      changelog = "https://github.com/nomic-ai/gpt4all/releases/tag/${version}";
      license = licenses.asl20;
      maintainers = with maintainers; [aldoborrero];
    };
  }
