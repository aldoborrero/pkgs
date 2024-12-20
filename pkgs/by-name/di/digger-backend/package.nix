{
  lib,
  buildGoModule,
  fetchFromGitHub,
}: let
  patchedAtlas = buildGoModule rec {
    pname = "atlas";
    version = "0.29.0";

    src = fetchFromGitHub {
      owner = "ariga";
      repo = "atlas";
      rev = "v${version}";
      hash = "sha256-synQZAOnX5Xw5d7pHPr7eaycf/YErktCjlsPVwbyLks=";
    };

    modRoot = "cmd/atlas";

    patches = [
      ./atlas-postgres-sockets.patch
    ];

    proxyVendor = true;
    vendorHash = "sha256-bQNcLFSMED5zFxf319fAeLLrVeZMCV/33s9hCm1elFs=";

    ldflags = [
      "-s"
      "-w"
      "-X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v${version}"
    ];

    subPackages = ["."];
  };
in
  buildGoModule rec {
    pname = "digger-backend";
    version = "0.6.79";

    src = fetchFromGitHub {
      owner = "diggerhq";
      repo = "digger";
      rev = "v${version}";
      hash = "sha256-/R52dwgKqpU9ffka5bz9xb7NyoCIu2/AgiWG0TT8nd0=";
    };

    patches = [
      ./fix-migrations-comment.patch
    ];

    vendorHash = "sha256-qcItUM2wQ4fgFDMGkyymxQugGaRQvn7rrmSzaLtL76Q=";
    proxyVendor = true;

    CGO_ENABLED = 0;

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
      cp -r backend/migrations $out/share/
      cp -r backend/templates $out/share/
    '';

    passthru.atlas = patchedAtlas;

    meta = with lib; {
      description = "Backend service for Digger, an open source IaC orchestration tool";
      homepage = "https://github.com/diggerhq/digger";
      license = licenses.asl20;
      mainProgram = "digger-backend";
      maintainers = with maintainers; [aldoborrero];
    };
  }
