{
  lib,
  buildGoModule,
  fetchFromGitHub,
  atlas,
}:
buildGoModule rec {
  pname = "digger-backend";
  version = "0.6.75";

  src = fetchFromGitHub {
    owner = "diggerhq";
    repo = "digger";
    rev = "v${version}";
    hash = "sha256-NPAdztX4SYNk7xLuiIxzkK/0EFEJ8s48f35PabhqaBs=";
  };

  vendorHash = "sha256-qcItUM2wQ4fgFDMGkyymxQugGaRQvn7rrmSzaLtL76Q=";
  proxyVendor = true;

  CGO_ENABLED = 0;

  nativeBuildInputs = [atlas];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  subPackages = ["backend"];

  postInstall = ''
    mkdir -p $out/share/digger-backend
    cp -r $src/backend/templates $out/share/digger-backend/
    cp -r $src/backend/migrations $out/share/digger-backend/
    cd $out/bin
    ln -s ../share/digger-backend/templates templates
    ln -s ../share/digger-backend/migrations migrations
    mv backend digger-backend
'';

  meta = with lib; {
    description = "Backend service for Digger, an open source IaC orchestration tool";
    homepage = "https://github.com/diggerhq/digger";
    license = licenses.asl20;
    mainProgram = "digger-backend";
    maintainers = with maintainers; [aldoborrero];
  };
}
