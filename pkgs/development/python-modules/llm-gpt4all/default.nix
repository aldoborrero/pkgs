{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  llm,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  gpt4all,
}:
buildPythonPackage rec {
  pname = "llm-gpt4all";
  version = "0.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "simonw";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-wV8k9XIDmbAjj/LJIOjNX5bBzc3ZjXOX5sJsY8U1WXc=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  buildInputs = [
    llm
  ];

  propagatedBuildInputs = [
    gpt4all
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Tests will try to download files from huggingface
  doCheck = false;

  pythonImportsCheck = [
    "llm_gpt4all"
  ];

  meta = with lib; {
    homepage = "https://github.com/simonw/llm-gpt4all";
    description = "Plugin for LLM adding support for the GPT4All collection of models";
    changelog = "https://github.com/simonw/llm-gpt4all/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [aldoborrero];
  };
}
