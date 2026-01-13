{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.services.nfs-server;
in {
  options.${namespace}.services.nfs-server = {
    enable = mkEnableOption "Enable NFS-server service";
  };

  config = mkIf (cfg.enable && config.services.tailscale.enable) {
    services.nfs.server = {
      enable = true;
      exports = ''
        /mnt/storage/NAS 100.64.0.0/10(rw,no_subtree_check,insecure,async)
      '';
    };
  };
}
