{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule rec {
  pname = "chartify";
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "helmfile";
    repo = "chartify";
    rev = "v${version}";
    hash = "sha256-kxyBVGnvc6XvktpRVEAqymHdLMAlHd/i4gVovJ6n6To=";
  };

  vendorHash = "sha256-5q1DwKCPUxSZRc+Ov3v3VV5rdp4isdM+IYwpN6+EpsQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  subPackages = [
    "cmd/chartify"
    "cmd/chartreposerver"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Convert K8s manifests/Kustomization into Helm Chart";
    homepage = "https://github.com/helmfile/chartify";
    license = licenses.asl20;
    maintainers = with maintainers; [aldoborrero];
    mainProgram = "chartify";
  };
}
