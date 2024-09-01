{inputs, ...}: {
  imports = [
    inputs.home-manager.nixosModules.default
    ./system.nix
    ./users.nix
    ./gpg.nix
    ./openssh.nix
    ./secrets.nix
    ./security.nix
    ./nix.nix
  ];
}
