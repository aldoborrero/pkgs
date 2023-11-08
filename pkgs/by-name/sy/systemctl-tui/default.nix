{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "systemctl-tui";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "rgwood";
    repo = pname;
    rev = "1b6d80bfc2900cfd8e98640f4db4ae4902cd8a96";
    hash = "sha256-v+Or7F5AjENG6pLrQRUZWRe1PJ/DGdu2YHnlZ0o/UbE=";
  };

  cargoHash = "sha256-GNuWag8Y1aSkBMzXcHpwfVU80zmhusLIOrKtZSe/jI0=";

  meta = with lib; {
    description = "Ethereum consensus client in Rust";
    homepage = "https://github.com/sigp/lighthouse";
    mainProgram = pname;
    maintainers = with maintainers; [aldoborrero];
  };
}
