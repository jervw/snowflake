{
  pkgs,
  lib,
  ...
}: {
  imports = [
  (import ./disko.nix { device = "/dev/nvme1n1"; })
    ./hardware-configuration.nix
    ../../modules/nixos
    ../../modules/core
    ../../modules/virtualisation
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true; # Let Lanzaboote handle this
      efi.canTouchEfiVariables = true;
    };
    lanzaboote = {
      enable = false;
      pkiBundle = "/etc/secureboot";
    };
    initrd.systemd = {
      enable = false;
      enableTpm2 = false;
    };
  };

  environment.systemPackages = with pkgs; [tpm2-tss];

  networking = {
    hostName = "loki";
    networkmanager.enable = true;
    firewall.checkReversePath = false;
  };

  # Services
  services = {
    passSecretService.enable = true;
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    tailscale.enable = true;

    udev = {
      packages = with pkgs; [yubikey-personalization vial];
    };

    # Audio
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
