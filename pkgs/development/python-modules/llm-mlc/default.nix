{
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  lib,
  llm,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:
buildPythonPackage rec {
  pname = "llm-mlc";
  version = "0.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "simonw";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-OZUDEh1rt995BIiB7i2AjmFHRcd7Ls24FQSVJI8r/k8=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  buildInputs = [
    llm
  ];

  propagatedBuildInputs = [
    httpx
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Fix tests by preventing them from writing to /homeless-shelter.
  preCheck = "export HOME=$(mktemp -d)";

  # Tests are performed against HuggingFace downloading extra models
  doCheck = true;

  pythonImportsCheck = [
    "llm_mlc"
  ];

  meta = with lib; {
    homepage = "https://github.com/simonw/llm-mlc";
    description = "LLM plugin for running models using MLC";
    changelog = "https://github.com/simonw/llm-mlc/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [aldoborrero];
  };
}
