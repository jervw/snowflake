{ pkgs, lib, user, ...}:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot/efi";
  };

  # NVIDIA specific stuff
  hardware = {
    opengl.enable = true;
    nvidia.modesetting.enable = true;
  };

  # Networking
  networking = {
    networkmanager.enable = true;
    hostName = "loki";
  };

  # System packages
  environment.systemPackages = with pkgs; [
    xclip
  ];

  # Services
  services = {
    openssh.enable = false;

    # Xorg 
    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];

      desktopManager.xterm.enable = false;
      displayManager.defaultSession = "none+i3";

      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
        extraPackages = with pkgs; [
          dmenu
          i3status-rust
          networkmanagerapplet
        ];
      };
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
