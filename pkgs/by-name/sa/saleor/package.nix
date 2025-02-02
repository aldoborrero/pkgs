{
  fetchFromGitHub,
  lib,
  python3,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "saleor";
  version = "3.20.65";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "saleor";
    repo = "saleor";
    rev = "v${version}";
    hash = "";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    pythonImportsCheckHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    poetry
  ];

  pythonImportsCheck = [
    "saleor"
  ];

  meta = with lib; {
    homepage = "https://saleor.io";
    description = "Saleor Core: the high performance, composable, headless commerce API";
    changelog = "https://github.com/saleor/saleor/releases/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [aldoborrero];
  };
}
