{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
    ../../modules/core
    ../../modules/virtualisation
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = lib.mkForce false; # Let Lanzaboote handle this
      efi.canTouchEfiVariables = true;
    };
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    initrd.systemd = {
      enable = true;
      enableTpm2 = true;
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
