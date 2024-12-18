{
  lib,
  buildGoModule,
  fetchFromGitHub,
  atlas,
}:
buildGoModule rec {
  pname = "digger-backend";
  version = "0.6.79";

  src = fetchFromGitHub {
    owner = "diggerhq";
    repo = "digger";
    rev = "v${version}";
    hash = "sha256-/R52dwgKqpU9ffka5bz9xb7NyoCIu2/AgiWG0TT8nd0=";
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
    mv $out/bin/backend $out/bin/digger-backend

    # copy migrations
    mkdir -p $out/share/
    cp -r $src/backend/migrations $out/share/
    cp -r $src/backend/templates $out/share/
  '';

  meta = with lib; {
    description = "Backend service for Digger, an open source IaC orchestration tool";
    homepage = "https://github.com/diggerhq/digger";
    license = licenses.asl20;
    mainProgram = "digger-backend";
    maintainers = with maintainers; [aldoborrero];
  };
}
