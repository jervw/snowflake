{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/core
    ../../modules/virtualisation
    ../../modules/nvidia.nix
    ../../modules/wayland.nix
    # ../../modules/quiet.nix
    ../../modules/syncthing.nix
  ];

  boot = {
    # kernelPackages = pkgs.linuxPackages_xanmod_latest;
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  programs.gamemode.enable = true;

  hardware.xone.enable = true;
  environment.systemPackages = with pkgs; [linuxKernel.packages.linux_zen.xone];

  networking = {
    hostName = "loki";
    networkmanager.enable = true;
    firewall.checkReversePath = false;
  };

  # Services
  services = {
    passSecretService.enable = true;
    gnome.gnome-keyring.enable = true;

    udev = {
      packages = with pkgs; [yubikey-personalization vial via];
    };

    # Auto mounting
    gvfs.enable = true;

    # Audio
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
