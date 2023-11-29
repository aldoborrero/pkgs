{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  llm,
  pytestCheckHook,
  pythonOlder,
  sentence-transformers,
  setuptools,
}:
buildPythonPackage rec {
  pname = "llm-markov";
  version = "0.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "simonw";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "";
  };

  nativeBuildInputs = [
    setuptools
  ];

  buildInputs = [
    llm
  ];

  propagatedBuildInputs = [
    sentence-transformers
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Tests will try to download files from huggingface
  doCheck = true;

  pythonImportsCheck = [
    "llm_markov"
  ];

  meta = with lib; {
    homepage = "https://github.com/simonw/llm-markov";
    description = "Plugin for LLM adding a Markov chain generating model";
    changelog = "https://github.com/simonw/llm-markov/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [aldoborrero];
  };
}
