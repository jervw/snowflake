{pkgs, ...}: {
  time.timeZone = "Europe/Helsinki";
  i18n.defaultLocale = "en_US.UTF-8";

  environment = {
    systemPackages = with pkgs; [
      git
      glib
      killall
      python3
      unzip
      zip
      zfs
      file
      ffmpeg
      libnotify
      tpm2-tss
    ];
  };

  services.udev = {
    packages = with pkgs; [yubikey-personalization vial];
  };

  # allow users to mount fuse filesystems with allow_other
  programs.fuse.userAllowOther = true;

  system.stateVersion = "23.11";
}
