{ pkgs, lib, user, ... }:

{
  imports =
    #[ ./../modules/virtualisation ] ++
    [ (import ./hardware-configuration.nix) ] ++
    [ (import ../../modules/desktop/nvidia.nix) ] ++
    [ (import ../../modules/desktop/hyprland) ];

  boot = {
    kernelParams = [ "quiet" "rd.systemd.show_status=false" "rd.udev.log_level=3" "udev.log_priority=3" ];
    consoleLogLevel = 0;
    plymouth.enable = true;
    kernelPackages = pkgs.linuxPackages_latest;
    initrd = {
      verbose = false;
      systemd.enable = true;
    };
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 1;
    };
  };

  systemd.watchdog.rebootTime = "0";

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
    #mingetty.autologinUser = user;
    openssh.enable = true;
    passSecretService.enable = true;
    gnome.gnome-keyring.enable = true;
    flatpak.enable = true;

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
