{
  anthropic,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  llm,
  pydanticv2,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:
buildPythonPackage rec {
  pname = "llm-claude";
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "tomviner";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-lC0Tx7zeM8gZ3Ln8VWkq29BsKsMnxHB3s+R086B5BEs=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  buildInputs = [
    llm
  ];

  propagatedBuildInputs = [
    anthropic
    pydanticv2
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "llm_claude"
  ];

  meta = with lib; {
    homepage = "https://github.com/tomviner/llm-claude";
    description = "Plugin for LLM adding support for Anthropic's Claude models";
    changelog = "https://github.com/tomviner/llm-claude/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [aldoborrero];
  };
}
