{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/core
    ../../modules/virtualisation
    ../../modules/nvidia.nix
    ../../modules/wayland.nix
    ../../modules/quiet.nix
    ../../modules/greetd.nix
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

  networking.networkmanager.enable = true;
  networking.firewall.checkReversePath = false;

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
      packages = [pkgs.yubikey-personalization];
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
