{ pkgs, user, ... }:

{
  imports =
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

  # Services
  services = {
    getty.autologinUser = user;
    openssh.enable = true;
    passSecretService.enable = true;
    gnome.gnome-keyring.enable = true;

    udev = {
      packages = [ pkgs.yubikey-personalization ];
    };

    # backups
    restic = {
      backups.${user} = {
        initialize = true;
        user = user;
        paths = ["/home/${user}"];
        passwordFile = "/etc/nixos/secrets/restic.txt";
        repository = "sftp:jervw@thor.asgard:/mnt/ext/Backups/restic";
        timerConfig = {
          OnUnitActiveSec = "1d";
        };
        pruneOpts = [
          "--keep-daily 7"
        ];
        exclude = [
          ".cache/"
          ".local/"
          ".config/"
          ".cargo/"
          ".rustup/"
          "Downloads/"
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
