{
  # create a default nixos module which mixes in all modules
  flake.nixosModules.default = {
    imports = [
      ./actual-server.nix
      ./ollama.nix
    ];
  };
}
