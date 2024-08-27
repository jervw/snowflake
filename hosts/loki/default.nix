{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix

    ../../modules/core
    ../../modules/nixos
    ../../modules/virtualisation
    ../../modules/network
    ../../modules/hardware
    ../../modules/services
  ];

  programs.nix-ld.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_cachyos;
}
