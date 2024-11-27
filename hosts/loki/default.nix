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

  networking.firewall.allowedTCPPorts = [10767]; # Cider2 RPC

  programs.nix-ld.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
}
