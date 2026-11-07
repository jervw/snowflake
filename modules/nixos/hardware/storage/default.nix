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
    zfs = mkBoolOpt false "Whether or not to enable support for ZFS filesystem.";
    extra = mkBoolOpt false "Whether or not to enable support for extra filesystems.";
  };

  config = mkMerge [
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
      services.zfs = {
        autoScrub.enable = true;
      };
    })

    (mkIf cfg.extra {
      environment.systemPackages = with pkgs; [
        btrfs-progs
        nfs-utils
        ntfs3g
      ];
    })
  ];
}
