{ pkgs, lib, user, ... }:

{
  imports =
    [ (import ./hardware-configuration.nix) ] ++
    [ (import ../../modules/desktop/nvidia.nix) ] ++
    [ (import ../../modules/desktop/hyprland) ];

  boot = {
    initrd.systemd.enable = true;
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

  environment = {
    systemPackages = with pkgs; [
      tpm2-tss
    ];
  };


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
