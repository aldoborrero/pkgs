{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  llm,
  pytestCheckHook,
  scikit-learn,
  setuptools,
  pythonOlder,
}:
buildPythonPackage rec {
  pname = "llm-cluster";
  version = "0.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "simonw";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-lNKy8aayMy0L48LaZWocn5pk5t3sReOSJj2sRENDuoE=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  buildInputs = [
    llm
  ];

  propagatedBuildInputs = [
    scikit-learn
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Fix tests by preventing them from writing to /homeless-shelter.
  preCheck = "export HOME=$(mktemp -d)";
  LOKY_MAX_CPU_COUNT = "1"; # Avoid issue with querying lscpu for obtaining cores

  pythonImportsCheck = [
    "llm_cluster"
  ];

  meta = with lib; {
    homepage = "https://github.com/simonw/llm-cluster";
    description = "LLM plugin for clustering embeddings";
    changelog = "https://github.com/simonw/llm-cluster/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [aldoborrero];
  };
}
