{
  fetchFromGitHub,
  lib,
  python311Packages,
  pythonOlder,
}:
python311Packages.buildPythonPackage rec {
  pname = "pyemvue";
  version = "0.17.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "magico13";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-laNo+utrlmf2Rol+bedc5v5I8f80J5shmSCKLXUhmFg=";
  };

  nativeBuildInputs = with python311Packages; [
    setuptools
  ];

  propagatedBuildInputs = with python311Packages; [
    pycognito
    python-dateutil
    requests
    typing-extensions
  ];

  nativeCheckInputs = with python311Packages; [
    pytestCheckHook
  ];

  doCheck = false;

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
