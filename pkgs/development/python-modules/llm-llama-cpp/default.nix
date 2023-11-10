{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  llm,
  pytestCheckHook,
  httpx,
  setuptools,
  pythonOlder,
}:
buildPythonPackage rec {
  pname = "llm-llama-cpp";
  version = "0.2b1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "simonw";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-WEokiLG+K5EbC2u+gCgxH5QqLXA6E31+sA51pr79a8g=";
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

  pythonImportsCheck = [
    "llm_llama_cpp"
  ];

  meta = with lib; {
    homepage = "https://github.com/simonw/llm-llama-cpp";
    description = "LLM plugin for running models using llama.cpp";
    changelog = "https://github.com/simonw/llm-llama-cpp/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [aldoborrero];
  };
}
