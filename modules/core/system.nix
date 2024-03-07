{pkgs, ...}: {
  time.timeZone = "Europe/Helsinki";
  i18n.defaultLocale = "en_US.UTF-8";

  system.activationScripts.diff = ''
    if [[ -e /run/current-system ]]; then
      echo "NixOS system closure diff:"
      ${pkgs.nix}/bin/nix store diff-closures /run/current-system "$systemConfig"
    fi
  '';

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
    ];
  };

  # allow users to mount fuse filesystems with allow_other
  programs.fuse.userAllowOther = true;

  system.stateVersion = "23.11";
}
