{
  fetchFromGitHub,
  lib,
  python311Packages,
}:
python311Packages.buildPythonPackage rec {
  pname = "mlc-llm";
  version = "1.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mlc-ai";
    repo = pname;
    rev = "3358029fdc2c41aff06cd21f4055165aa9e8cf14";
    hash = "sha256-NrPaMr2XlSsNcAhOfjJobo03jZ8wb0E2FDD4KXmvX1w=";
  };
  sourceRoot = "source/python";

  buildInputs = with python311Packages; [
    setuptools
  ];

  nativeCheckInputs = with python311Packages; [
    pythonImportsCheckHook
  ];

  propagatedBuildInputs = with python311Packages; [
    fastapi
    shortuuid
    uvicorn
  ];

  pythonImportsCheck = [
    "mlc_chat"
  ];

  meta = with lib; {
    homepage = "https://github.com/mlc-ai/mlc-llm";
    description = "Enable everyone to develop, optimize and deploy AI models natively on everyone's devices";
    license = licenses.asl20;
    maintainers = with maintainers; [aldoborrero];
  };
}
