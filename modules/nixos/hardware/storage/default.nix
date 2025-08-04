{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkMerge mkDefault;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.hardware.storage;
in {
  options.${namespace}.hardware.storage = {
    ssd = mkBoolOpt false "Whether or not to enable support for SSD storage devices.";
    zfs = mkBoolOpt false "Whether or not to enable support for ZFS filesystem.";
    extra = mkBoolOpt false "Whether or not to enable support for extra filesystems.";
  };

  config = mkMerge [
    (mkIf cfg.ssd {
      services.fstrim.enable = mkDefault true;
    })

    # TODO: Maybe someday make pools configurable
    # Enable ZFS support
    (mkIf cfg.zfs {
      boot = {
        supportedFilesystems = {
          zfs = mkDefault true;
        };
        zfs = {
          forceImportRoot = false;
          extraPools = ["zpool"];
        };
      };
    })

    # Extra storage tools
    (mkIf cfg.extra {
      environment.systemPackages = with pkgs; [
        btrfs-progs
        fuseiso
        nfs-utils
        ntfs3g
      ];
    })
  ];
}
