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
    opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [ nvidia-vaapi-driver ];
    };
    nvidia = {
      open = true;
      powerManagement.enable = true;
      modesetting.enable = true;
    };
  };

  environment = {
    variables = {
      GBM_BACKEND = "nvidia-drm";
      LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };
    systemPackages = with pkgs; [
      xclip
      vulkan-loader
      vulkan-validation-layers
      vulkan-tools
    ];
  };

  # Networking
  networking = {
    networkmanager.enable = true;
    hostName = "loki";
  };

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
      };

      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          dmenu-rs
          i3status-rust
          j4-dmenu-desktop
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
