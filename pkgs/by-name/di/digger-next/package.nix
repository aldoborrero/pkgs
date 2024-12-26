{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs_18,
  nodePackages,
}:
stdenv.mkDerivation rec {
  pname = "digger-next";
  version = "0.1.0-dev";

  src = fetchFromGitHub {
    owner = "diggerhq";
    repo = "next";
    rev = "main";
    sha256 = "";
  };

  nativeBuildInputs = [
    nodejs_18
    nodePackages.pnpm
  ];

  configurePhase = ''
    export HOME=$(mktemp -d)
    pnpm config set store-dir $HOME/.pnpm-store
  '';

  buildPhase = ''
    # Install dependencies
    pnpm install

    # Build the Next.js application
    CI=true pnpm run build
  '';

  installPhase = ''
    mkdir -p $out/lib/node_modules/digger-next
    cp -r . $out/lib/node_modules/digger-next

    mkdir -p $out/bin
    cat > $out/bin/digger-next <<EOF
    #!${stdenv.shell}
    exec ${nodejs_18}/bin/node $out/lib/node_modules/digger-next/server.js
    EOF

    chmod +x $out/bin/digger-next
  '';

  meta = with lib; {
    description = "Digger Next.js Application";
    homepage = "https://github.com/diggerhq/next";
    license = licenses.mit; # Verify the actual license
    platforms = platforms.unix;
    maintainers = with maintainers; []; # Add maintainers if needed
  };
}
