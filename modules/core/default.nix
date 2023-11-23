{ inputs, ...}:

{
  imports = [
    inputs.nh.nixosModules.default
    ./system.nix
    ./users.nix
    ./fonts.nix
    ./security.nix
    ./nix.nix
  ];
}
