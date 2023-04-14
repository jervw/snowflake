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
      open = true;
      powerManagement.enable = true;
      modesetting.enable = true;
    };
  };

  environment = {
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
    xserver.videoDrivers = [ "nvidia" ];

    openssh.enable = false;

    # Audio
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
