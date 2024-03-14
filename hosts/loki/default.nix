{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
    ../../modules/core
    ../../modules/services
    ../../modules/virtualisation
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = lib.mkForce false; # Let Lanzaboote handle this
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    networkmanager.enable = true;
    firewall.checkReversePath = "loose";
  };

  # Services
  services = {
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;

    fstrim.enable = true;
  };
}
