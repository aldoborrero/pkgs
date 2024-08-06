{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "kbld";
  version = "0.44.0";

  src = fetchFromGitHub {
    owner = "carvel-dev";
    repo = "kbld";
    rev = "v${version}";
    hash = "sha256-JzL2spSCCGpNBuhTwVnavEwPklaH91GDhrBCuHE3xj8=";
  };

  vendorHash = null;

  subPackages = ["cmd/kbld"];

  meta = with lib; {
    description = "Carvel tool for building, pushing and referencing container images in Kubernetes configuration files";
    homepage = "https://github.com/carvel-dev/kbld";
    license = licenses.asl20;
    maintainers = with maintainers; [aldoborrero];
    platforms = platforms.unix;
  };
}
