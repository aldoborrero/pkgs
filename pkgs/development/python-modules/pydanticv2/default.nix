# Extracted from https://github.com/NixOS/nixpkgs/pull/244564/commits/250768e7f76e24ca11f678d9d3bab96ab2735b07
{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-fancy-pypi-readme,
  hatchling,
  annotated-types,
  pydantic-core,
  typing-extensions,
  email-validator,
  pytestCheckHook,
  dirty-equals,
  pytest-examples,
  pytest-mock,
  faker,
}:
buildPythonPackage rec {
  pname = "pydantic";
  version = "2.0.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic";
    rev = "v${version}";
    hash = "sha256-Nx6Jmx9UqpvG3gMWOarVG6Luxgmt3ToUbmDbGQTHQto=";
  };

  patches = [
    ./01-remove-benchmark-flags.patch
  ];

  nativeBuildInputs = [
    hatch-fancy-pypi-readme
    hatchling
  ];

  propagatedBuildInputs = [
    annotated-types
    pydantic-core
    typing-extensions
  ];

  passthru.optional-dependencies = {
    email = [
      email-validator
    ];
  };

  pythonImportsCheck = ["pydantic"];

  nativeCheckInputs = [
    pytestCheckHook
    dirty-equals
    pytest-mock
    pytest-examples
    faker
  ];

  disabledTestPaths = [
    "tests/benchmarks"
    "tests/test_base64"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Data validation using Python type hints";
    homepage = "https://github.com/pydantic/pydantic";
    changelog = "https://github.com/pydantic/pydantic/blob/v${version}/HISTORY.md";
    license = licenses.mit;
    maintainers = with maintainers; [wd15];
  };
}
