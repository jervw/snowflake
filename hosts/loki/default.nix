{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core
    ../../modules/virtualisation
    ../../modules/nvidia.nix
    ../../modules/wayland.nix
    ../../modules/quiet.nix
    ../../modules/greetd.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "loki";
  };

  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "gnome3";
    enableSSHSupport = true;
  };

  # Services
  services = {
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
