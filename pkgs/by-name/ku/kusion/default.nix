{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule rec {
  pname = "kusion";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "KusionStack";
    repo = "kusion";
    rev = "v${version}";
    hash = "sha256-TA3g5aMM9HlW/l66PaJkUJ4TePt42PjegbHPEwQ5koI=";
  };

  vendorHash = "sha256-7MnxlKwdhva4GMOShEeGy1cBjOgvCX1x/pUYpizop9k=";

  subPackages = ["kusion.go"];

  meta = with lib; {
    description = "KusionStack's cloud-native application configuration and deployment tool";
    homepage = "https://github.com/KusionStack/kusion";
    license = licenses.asl20;
    maintainers = with maintainers; [aldoborrero];
    platforms = platforms.unix;
  };
}
