{
  buildPythonPackage,
  cmake,
  fetchFromGitHub,
  huggingface-hub,
  lib,
  ninja,
  pkg-config,
  py-cpuinfo,
  pytestCheckHook,
  pythonOlder,
  scikit-build,
  setuptools,
}:
buildPythonPackage rec {
  pname = "ctransformers";
  version = "0.2.27";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "marella";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-UFkXl4Q8QpZbztZzjpNQpUyTlvNCHBgPSEXtJhe3rcE=";
  };

  nativeBuildInputs = [
    setuptools
    pkg-config
    cmake
    scikit-build
    ninja
  ];

  propagatedBuildInputs = [
    huggingface-hub
    py-cpuinfo
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preBuild = ''
    cd ../
  '';

  # Tests are performed against HuggingFace downloading extra models
  doCheck = false;

  pythonImportsCheck = [
    "ctransformers"
  ];

  meta = with lib; {
    homepage = "https://github.com/marella/ctransformers";
    description = "Python bindings for the Transformer models implemented in C/C++ using GGML library";
    changelog = "https://github.com/marella/ctransformers/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [aldoborrero];
  };
}
