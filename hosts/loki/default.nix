{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix

    ../../modules/core
    ../../modules/extra
    ../../modules/hardware
    ../../modules/network
    ../../modules/services
    ../../modules/virtualisation
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernelPackages = pkgs.linuxPackages_latest;
  };
}
