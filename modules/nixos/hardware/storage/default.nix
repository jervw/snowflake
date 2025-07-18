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
    extra = mkBoolOpt false "support for extra storage devices";
  };

  config = mkMerge [
    (mkIf cfg.ssd {
      services.fstrim.enable = mkDefault true;
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
