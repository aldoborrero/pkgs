{
  python311Packages,
  fetchPypi,
  lib,
}:
python311Packages.buildPythonPackage rec {
  pname = "pyemvue";
  version = "0.17.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DipZIQOrYVFa5nF0DPHHmL+eEkR/tK7nH+0m1ElRGqU=";
  };

  propagatedBuildInputs = with python311Packages; [
    pycognito
    python-dateutil
    requests
    typing-extensions
  ];

  nativeCheckInputs = with python311Packages; [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyemvue"
  ];

  meta = with lib; {
    homepage = "https://github.com/magico13/PyEmVue";
    description = "Python Library for the Emporia Vue Energy Monitor Resources";
    changelog = "https://github.com/magico13/PyEmVue/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [aldoborrero];
  };
}
