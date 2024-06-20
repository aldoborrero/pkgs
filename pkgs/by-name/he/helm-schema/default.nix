{
  buildGo122Module,
  fetchFromGitHub,
  lib,
}:
buildGo122Module rec {
  pname = "helm-schema";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "dadav";
    repo = "helm-schema";
    rev = "${version}";
    hash = "sha256-XqicqzHF/4jJM1SQnFfVMoKHWp2eRxRjH2E09m0i/iI=";
  };

  vendorHash = "sha256-QjzCgMqAuWTqJhwRHWV92ntwWbBy137Dipkin36AylU=";

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = false;

  subPackages = ["cmd/helm-schema"];

  meta = with lib; {
    description = "Generate jsonschemas from helm charts";
    homepage = "https://github.com/dadav/helm-schema";
    license = licenses.mit;
    maintainers = with maintainers; [aldoborrero];
  };
}
