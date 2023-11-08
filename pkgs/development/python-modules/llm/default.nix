{
  buildPythonApplication,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  makeWrapper,
  pytestCheckHook,
  python3,
  pythonOlder,
  ruff,
  setuptools,
}: let
  llm = buildPythonPackage rec {
    pname = "llm";
    version = "0.12";
    pyproject = true;

    disabled = pythonOlder "3.8";

    src = fetchFromGitHub {
      owner = "simonw";
      repo = pname;
      rev = "refs/tags/${version}";
      hash = "sha256-aCqdw2co/cXrBwVY/k/aSLl3C22nlH5LvU2yir1/NnQ=";
    };

    nativeBuildInputs = [
      setuptools
    ];

    propagatedBuildInputs = with python3.pkgs; [
      click-default-group
      openai
      pip
      pluggy
      pydantic
      python-ulid
      pyyaml
      sqlite-migrate
      sqlite-utils
      setuptools # for pkg_resources
    ];

    nativeCheckInputs = with python3.pkgs; [
      black
      cogapp
      mypy
      numpy
      pytestCheckHook
      requests-mock
      ruff
      types-click
      types-pyyaml
      types-requests
      types-setuptools
    ];

    doCheck = true;

    pytestFlagsArray = [
      "-svv"
      "tests/"
    ];

    pythonImportsCheck = [
      "llm"
    ];

    passthru = {inherit withPlugins;};

    meta = with lib; {
      homepage = "https://github.com/simonw/llm";
      description = "Access large language models from the command-line";
      changelog = "https://github.com/simonw/llm/releases/tag/${version}";
      license = licenses.asl20;
      mainProgram = "llm";
      maintainers = with maintainers; [aldoborrero];
    };
  };

  withPlugins = plugins:
    buildPythonApplication {
      inherit (llm) pname version;
      format = "other";

      disabled = pythonOlder "3.8";

      dontUnpack = true;
      dontBuild = true;
      doCheck = false;

      nativeBuildInputs = [
        makeWrapper
      ];

      installPhase = ''
        makeWrapper ${llm}/bin/llm $out/bin/llm \
          --prefix PYTHONPATH : "${llm}/${python3.sitePackages}:$PYTHONPATH"
        ln -sfv ${llm}/lib $out/lib
      '';

      propagatedBuildInputs = llm.propagatedBuildInputs ++ plugins;

      passthru =
        llm.passthru
        // {
          withPlugins = morePlugins: withPlugins (morePlugins ++ plugins);
        };

      meta.mainProgram = "llm";
    };
in
  llm
