{
  lib,
  pkgs,
  config,
  ...
}:
lib.mkIf (config.services.tailscale.enable) {
  # NAS through Tailscale
  environment.systemPackages = with pkgs; [nfs-utils];
  boot.initrd = {
    supportedFilesystems = ["nfs"];
    kernelModules = ["nfs"];
  };

  fileSystems."/mnt/share" = {
    device = "thor:/mnt/storage/NAS";
    fsType = "nfs";
    options = ["rw" "noauto" "x-systemd.automount" "x-systemd.idle-timeout=600"];
  };
}
