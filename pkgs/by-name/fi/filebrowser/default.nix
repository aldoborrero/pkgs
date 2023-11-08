{
  lib,
  buildGoModule,
  fetchFromGitHub,
  buildNpmPackage,
}: let
  pname = "filebrowser";
  version = "2.26.0";

  src = fetchFromGitHub {
    owner = "filebrowser";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-gbn0k2JCEzBV3Q0LcwsoDpmF/z62PqKqgA6EJG35Xvc=";
  };

  frontend = buildNpmPackage {
    inherit pname version src;

    sourceRoot = "source/frontend";

    npmDepsHash = "sha256-i2+0XPea3KuuGSdko29mVm2z3i/beDe/vF4j2iFv7WA=";

    # The prepack script runs the build script, which we'd rather do in the build phase.
    npmPackFlags = ["--ignore-scripts"];
    npmFlags = ["--legacy-peer-deps"];

    # We only care about dist
    installPhase = ''
      mkdir -p $out
      cp -r dist/* $out
    '';
  };

  app = buildGoModule {
    inherit pname version src;

    vendorHash = "sha256-juVP7oRLcYmywGu+ueXGiQwTxk538T6SYOhWf8Us4bg=";

    subPackages = ["."];

    ldflags = [
      "-s"
      "-w"
    ];

    # copy frontend to frontend/dist for filebrowser to use
    postPatch = ''
      cp -r ${frontend}/* frontend/dist/
    '';

    meta = with lib; {
      description = "Web File Browser";
      homepage = "https://github.com/filebrowser/filebrowser";
      changelog = "https://github.com/filebrowser/filebrowser/releases/tag/v${version}";
      license = licenses.mit;
      mainProgram = "filebrowser";
      maintainers = with maintainers; [aldoborrero];
    };
  };
in
  app
