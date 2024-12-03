{
  pkgs,
  stdenv,
}:
stdenv.mkDerivation rec {
  name = "caddy";
  version = "2.8.4";

  nativeBuildInputs = with pkgs; [go xcaddy cacert];

  unpackPhase = "true";

  buildPhase = ''
    export GOCACHE=$TMPDIR/go-cache
    export GOPATH="$TMPDIR/go"
    XCADDY_SKIP_BUILD=1 TMPDIR="$PWD" \
      xcaddy build v${version} --with github.com/caddy-dns/cloudflare@v0.0.0-20240703190432-89f16b99c18e
    (cd buildenv* && go mod vendor)
  '';

  installPhase = ''
    mv buildenv* $out
  '';

  outputHash = "sha256-LLbZtmX/B+oQDqAJNIZigIQrqmJ3QwUBcQxjgwJkNlo=";
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";

  meta = {
    mainProgram = "caddy";
  };
}
