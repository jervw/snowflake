{ pkgs, lib, user, ... }:

{
  imports =
    [ (import ./hardware-configuration.nix) ] ++
    [ (import ../../modules/desktop/hyprland/default.nix) ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot/efi";
  };

  # NVIDIA specific stuff
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs;
        [
          nvidia-vaapi-driver
          vaapiVdpau
          libvdpau-va-gl
        ];
    };
    nvidia = {
      open = true; # testing
      powerManagement.enable = true;
      modesetting.enable = true;
    };
    bluetooth.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      vulkan-loader
      vulkan-validation-layers
      vulkan-tools
      xclip
      libva
      libva-utils
      glxinfo
      egl-wayland
    ];
  };

  # Networking
  networking = {
    networkmanager.enable = true;
    hostName = "loki";
  };

  programs.dconf.enable = true;

  # Services
  services = {
    xserver.videoDrivers = [ "nvidia" ];

    openssh.enable = true;
    passSecretService.enable = true;

    gnome.gnome-keyring.enable = true;

    # Audio
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    blueman = {
      enable = true;
    };
    flatpak = {
      enable = true;
    };
  };
}
