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

    ../../modules/network/networkmanager.nix
    ../../modules/network/tailscale.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = lib.mkForce false; # Let Lanzaboote handle this
      efi.canTouchEfiVariables = true;
    };
  };

  # Services
  services = {
    gnome.gnome-keyring.enable = true;
    fstrim.enable = true;
    gvfs.enable = true;
  };
}
