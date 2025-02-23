{inputs, ...}: {
  imports = [
    inputs.home-manager.nixosModules.default
    inputs.agenix.nixosModules.default
    inputs.self.nixosModules.beszel
    inputs.nix-index.nixosModules.nix-index
    ./system.nix
    ./users.nix
    ./gpg.nix
    ./openssh.nix
    ./security.nix
    ./nix.nix
  ];
}
