{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "helm-images";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "nikhilsbhat";
    repo = "helm-images";
    rev = "v${version}";
    hash = "sha256-22XI6IKXAiZlOl/1oHdQo3c1VEMGivjmvZdnTcQsa1U=";
  };

  vendorHash = "sha256-u85pYLykWffTwf2ro9l1Xec+WYOZhQNI8+Dkl8jIbZM=";

  ldflags = ["-s" "-w"];

  postPatch = ''
    sed -i '/^hooks:/,+2 d' plugin.yaml
  '';

  postInstall = ''
    install -dm755 $out/${pname}
    mv $out/bin $out/${pname}/
    mv $out/${pname}/bin/{helm-,}images
    mv $out/${pname}/bin/images $out/${pname}/bin/helm-images
    install -m644 -Dt $out/${pname} plugin.yaml
  '';

  meta = with lib; {
    description = "Helm plugin to identify all images that would be part of helm chart deployment";
    homepage = "https://github.com/nikhilsbhat/helm-images";
    license = licenses.mit;
    maintainers = with maintainers; [aldoborrero];
  };
}
