{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix

    ../../modules/core
    ../../modules/nixos
    ../../modules/virtualisation
    ../../modules/network
    ../../modules/services
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos;
    # loader = {
    #   efi.canTouchEfiVariables = true;
    # };
  };
}
