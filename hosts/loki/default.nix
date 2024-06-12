{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    ../../modules/core
    ../../modules/nixos
    ../../modules/virtualisation
    ../../modules/network
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos;
    loader = {
      systemd-boot.enable = lib.mkForce false; # Let Lanzaboote handle this
      efi.canTouchEfiVariables = true;
    };
  };

  programs.gamemode.enable = true;

  # Services
  services = {
    gnome.gnome-keyring.enable = true;
    fstrim.enable = true;
    gvfs.enable = true;
  };
}
