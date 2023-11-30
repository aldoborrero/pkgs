{
  buildPythonApplication,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  python3,
  pythonOlder,
  poetry-core,
}:
buildPythonApplication rec {
  pname = "oterm";
  version = "0.1.11";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ggozad";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-5GXOdWDgvfRKEFMqxyPoTrGnFDwdQAA+tTfcTc9X2Ow=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    aiosql
    aiosqlite
    httpx
    packaging
    pyperclip
    python-dotenv
    textual
    typer
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    requests-mock
    pytest-asyncio
    textual-dev
  ];

  doCheck = false;

  pytestFlagsArray = [
    "-svv"
    "tests/"
  ];

  pythonImportsCheck = [
    "oterm"
  ];

  meta = with lib; {
    homepage = "https://github.com/ggozad/oterm";
    description = "A text-based terminal client for Ollama";
    changelog = "https://github.com/ggozad/oterm/releases/tag/${version}";
    license = licenses.mit;
    mainProgram = pname;
    maintainers = with maintainers; [aldoborrero];
  };
}
