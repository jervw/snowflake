{ pkgs, lib, user, ... }:

{
  imports =
    [ (import ./hardware-configuration.nix) ] ++
    [ (import ../../modules/nvidia.nix) ] ++
    [ (import ../../modules/wayland/hyprland) ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  # Networking
  networking = {
    networkmanager.enable = true;
    hostName = "loki";
  };

  programs.dconf.enable = true;

  # Services
  services = {
    openssh.enable = true;
    passSecretService.enable = true;
    gnome.gnome-keyring.enable = true;

    udev = {
      packages = [ pkgs.yubikey-personalization ];
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
