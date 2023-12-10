{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  buildPythonApplication,
  python311Packages,
}: let
  name = "ollama-webui";
  version = "0.0.0-dev";

  src = fetchFromGitHub {
    owner = name;
    repo = name;
    rev = "92ced39a81bf758cc1ff97e04e42811dc078fce9";
    hash = "sha256-GGC7uWOKegTckEDUsPV9p7LckZo+HXRtc9RHZeupRnQ=";
  };

  ui = buildNpmPackage {
    pname = "${name}-frontend";

    inherit version src;

    npmDepsHash = "sha256-N+wyvyKqsDfUqv3TQbxjuf8DF0uEJ7OBrwdCnX+IMZ4=";

    installPhase = ''
      mkdir -p $out/
      mv build $out
    '';

    env = {
      PUBLIC_API_BASE_URL = "/ollama/api";
    };
  };
in
  buildPythonApplication {
    pname = name;
    inherit src version;
    pyproject = true;

    postUnpack = ''
      # delete requirements.txt
      rm -rf $sourceRoot/backend/requirements.txt

      # provide our pyproject
      cp ${./pyproject.toml} $sourceRoot/pyproject.toml

      # copy run.py
      cp -R ${./run.py} $sourceRoot/backend/run.py

      # rename backend
      mv $sourceRoot/backend $sourceRoot/ollama_webui
    '';

    postInstall = ''
      cp -r ${ui}/build $out/build
    '';

    propagatedBuildInputs = with python311Packages; [
      fastapi
      uvicorn
      python-multipart
      flask
      flask-cors
      python-socketio
      python-jose
      passlib
      uuid
      requests
      pymongo
      bcrypt
      pyjwt
    ];

    meta = with lib; {
      homepage = "https://github.com/ollama-webui/ollama-webui";
      description = "ChatGPT-Style Web UI Client for Ollama";
      platforms = ["x86_64-linux"];
      maintainers = with maintainers; [aldoborrero];
    };
  }
