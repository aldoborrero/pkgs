{
  buildGo122Module,
  fetchFromGitHub,
  lib,
}:
buildGo122Module rec {
  pname = "helm-schema";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "dadav";
    repo = "helm-schema";
    rev = "${version}";
    hash = "sha256-+GNslbdoqMHP/1AfsdLRpPnmjL/tmll3vem62bCmWpk=";
  };

  vendorHash = "sha256-7cE5qLALOYXCd7PrdG4OUvBpnY1eXQ+cWj25ywO82rE=";

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
