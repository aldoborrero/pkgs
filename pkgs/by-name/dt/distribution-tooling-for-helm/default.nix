{
  buildGo122Module,
  fetchFromGitHub,
  lib,
}:
buildGo122Module rec {
  pname = "dt";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "vmware-labs";
    repo = "distribution-tooling-for-helm";
    rev = "v${version}";
    hash = "sha256-KrQAlB0ORNzKIG2vxych3gVBytTh3Hhnjsyn1ia1ZQM=";
  };

  vendorHash = "sha256-T8Kk+9NAhYOvSq94HOEE53BT7Xh9tU1gJ420o/tiVEo=";

  ldflags = [
    "-s"
    "-w"
  ];

  postPatch = ''
    sed -i '/^hooks:/,+2 d' plugin.yaml
  '';

  postInstall = ''
    install -dm755 $out/${pname}
    mv $out/bin $out/${pname}/
    install -m644 -Dt $out/${pname} plugin.yaml
  '';

  subPackages = ["cmd/dt"];

  doCheck = false;

  meta = with lib; {
    description = "Helm Distribution plugin is is a set of utilities and Helm Plugin for making offline work with Helm Charts easier. It is meant to be used for creating reproducible and relocatable packages for Helm Charts that can be moved around registries without hassles. This is particularly useful for distributing Helm Charts into airgapped environments";
    homepage = "https://github.com/dadav/helm-schema";
    license = licenses.mit;
    maintainers = with maintainers; [aldoborrero];
    mainProgram = "dt";
  };
}
