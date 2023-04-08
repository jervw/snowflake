{ pkgs, lib, user, ... }:

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
      layout = "us,fi";
      xkbOptions = "grp:win_space_toggle";

      desktopManager.xterm.enable = false;

      displayManager = {
        defaultSession = "none+i3";
        sessionCommands = "${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-0 --mode 1920x1080 --pos 0x0 --rotate right --output DP-0 --primary --mode 2560x1440 --rate 143.97 --pos 1080x106 --rotate normal --output DP-1 --off --output DP-2 --off --output DP-3 --off --output DP-4 --off --output DP-5 --off";
      };

      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
        extraPackages = with pkgs; [
          dmenu-rs
          i3status-rust
          j4-dmenu-desktop
          i3-auto-layout
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
