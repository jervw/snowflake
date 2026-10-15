{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf types concatStringsSep mapAttrsToList;
  inherit (lib.${namespace}) mkOpt;
  cfg = config.${namespace}.services.nfs-server;

  # iOS apps can't bind privileged ports and send arbitrary uids; map them to jervw.
  ios = ["insecure" "all_squash" "anonuid=1000" "anongid=100"];
  # Windows NFS client presents uid 1000 itself.
  windows = ["insecure"];
in {
  options.${namespace}.services.nfs-server = with types; {
    enable = mkEnableOption "Enable NFS-server service";
    clients =
      mkOpt (attrsOf (listOf str)) {
        # loki
        "100.107.179.118" = [];
        "fd7a:115c:a1e0::8f01:b37a" = [];
        # fenrir
        "100.92.193.47" = [];
        "fd7a:115c:a1e0::6b01:c12f" = [];
        # loki-win
        "100.120.48.89" = windows;
        "fd7a:115c:a1e0::ef01:3060" = windows;
        # tyr
        "100.90.244.5" = ios;
        "fd7a:115c:a1e0::40da:f405" = ios;
      }
      "Tailscale IPs allowed to mount the export, with extra export options (Thor runs without MagicDNS, so no hostnames)";
  };

  config = mkIf (cfg.enable && config.services.tailscale.enable) {
    services.nfs.server = {
      enable = true;
      exports = ''
        /mnt/storage ${concatStringsSep " " (mapAttrsToList (ip: opts: "${ip}(${concatStringsSep "," (["rw" "no_subtree_check" "sync"] ++ opts)})") cfg.clients)}
      '';
    };

    # NFSv4 only needs 2049; rpcbind/mountd/statd stay closed.
    networking.firewall.interfaces.${config.services.tailscale.interfaceName}.allowedTCPPorts = [2049];
  };
}
