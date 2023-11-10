{
  buildPythonPackage,
  ctransformers,
  fetchFromGitHub,
  huggingface-hub,
  lib,
  llm,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  transformers,
}:
buildPythonPackage rec {
  pname = "llm-mpt30b";
  version = "0.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "simonw";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-LgaKgYyxBiP0SJr0BR8XIrz9K0hf+emK5ycSGxUIdfQ=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  buildInputs = [
    llm
  ];

  propagatedBuildInputs = [
    ctransformers
    transformers
    huggingface-hub
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "llm_mpt30b"
  ];

  # Fix tests by preventing them from writing to /homeless-shelter.
  preCheck = "export HOME=$(mktemp -d)";

  meta = with lib; {
    homepage = "https://github.com/simonw/llm-mpt30b";
    description = "LLM plugin adding support for the MPT-30B language model";
    changelog = "https://github.com/simonw/llm-mpt30b/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [aldoborrero];
  };
}
