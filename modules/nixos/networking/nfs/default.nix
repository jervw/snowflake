{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.${namespace}.networking.nfs;
in {
  options.${namespace}.networking.nfs = {
    enable = lib.mkEnableOption "Enable Tailscale connected NFS storage";
  };

  config = mkIf (cfg.enable && config.services.tailscale.enable) {
    environment.systemPackages = [pkgs.nfs-utils];
    boot.initrd = {
      supportedFilesystems = ["nfs"];
      kernelModules = ["nfs"];
    };

    fileSystems."/mnt/share" = {
      device = "thor:/mnt/storage";
      fsType = "nfs";
      options = [
        "rw"
        "noauto"
        "x-systemd.automount"
        "x-systemd.idle-timeout=600"
        "_netdev"
        "x-systemd.mount-timeout=10s" # Fail faster on shutdown
      ];
    };
  };
}
