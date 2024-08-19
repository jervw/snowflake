{inputs, ...}: {
  imports = [
    inputs.home-manager.nixosModules.default
    inputs.chaotic.nixosModules.default
    ./system.nix
    ./users.nix
    ./gpg.nix
    ./openssh.nix
    ./security.nix
    ./nix.nix
  ];
}
