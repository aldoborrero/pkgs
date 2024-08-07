{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "imgpkg";
  version = "0.43.0";

  src = fetchFromGitHub {
    owner = "carvel-dev";
    repo = "imgpkg";
    rev = "v${version}";
    hash = "sha256-DbCRbXKtQRlGbYzvt0Tu/tN+rebr7suBWvJUouVZrTs=";
  };

  vendorHash = null;

  subPackages = ["cmd/imgpkg"];

  meta = with lib; {
    description = "Store and relocate OCI images and their associated configuration as OCI images";
    homepage = "https://github.com/carvel-dev/imgpkg";
    license = licenses.asl20;
    maintainers = with maintainers; [aldoborrero];
    platforms = platforms.unix;
  };
}
