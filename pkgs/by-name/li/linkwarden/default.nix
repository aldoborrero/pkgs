{
  fetchFromGitHub,
  fetchYarnDeps,
  fixup_yarn_lock,
  lib,
  nodePackages,
  nodejs_20,
  python3,
  stdenv,
  yarn,
  cacert,
  vips,
  prefetch-yarn-deps,
  glib,
  pkg-config,
  mkYarnPackage,
}: let
  name = "linkwarden";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "linkwarden";
    repo = name;
    rev = "refs/tags/v${version}";
    hash = "sha256-yThgtxt/EPt95mtyv+UtsY1ACdnOymkxvDUhWwuiLQI=";
  };

  yarnDeps = mkYarnPackage {
    pname = "${name}-yarn-deps";
    inherit version src;

    nativeBuildInputs = [
      cacert
      glib
      nodePackages.node-gyp
      nodePackages.node-pre-gyp
      nodejs_20
      prefetch-yarn-deps
      python3
      vips
      yarn
      pkg-config
    ];

    buildInputs = [
      glib
      vips
    ];

    offlineCache = fetchYarnDeps {
      yarnLock = "${src}/yarn.lock";
      hash = "sha256-VIlwuiB+TJxxyEuVVP5Qh3NhIKSf8bEUXB2+2Gqoeas=";
    };

    preBuild = ''
      export HOME=$(mktemp -d)

      # Make yarn install packages from our offline cache, not the registry
      yarn config --offline set yarn-offline-mirror $offlineCache

      # Fixup "resolved"-entries in yarn.lock to match our offline cache
      fixup-yarn-lock yarn.lock
    '';

    buildPhase = ''
      runHook preBuild

      # Install from our offline cache
      yarn install --offline --frozen-lockfile
    '';

    installPhase = ''
      mkdir $out
      mv node_modules $out
    '';

    env = {
      PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = 1;
    };

    # outputHashMode = "recursive";
    outputHash = "sha256-60NBM9Ntm5a9hf/KrXbH+d2zfBxAQ5U8vp8ptTbtN+0=";

    meta.platforms = ["x86_64-linux"];
  };
in yarnDeps
# stdenv.mkDerivation rec {
#   pname = name;
#   inherit version src;
#
#   buildInputs = [
#     yarn
#     nodejs_20
#   ];
#
#   preBuild = ''
#     export HOME=($mktemp -d)
#     ls .
#     ln -s ${yarnDeps}/node_modules/ ./node_modules
#   '';
#
#   buildPhase = ''
#     runHook preBuild
#
#     # yarn --offline run build
#     ./node_modules/.bin/next build
#   '';
#
#   installPhase = ''
#     mkdir -p $out/bin
#   '';
#
#   passthru = {
#     inherit yarnDeps;
#   };
#
#   meta = with lib; {
#     description = "Self-hosted collaborative bookmark manager to collect, organize, and preserve webpages";
#     homepage = "https://github.com/linkwarden/linkwarden";
#     changelog = "https://github.com/linkwarden/linkwarden/releases/tag/v${version}";
#     license = licenses.agpl3;
#     mainProgram = name;
#     platforms = ["x86_64-linux"];
#     maintainers = with maintainers; [aldoborrero];
#   };
# }
