{
  config,
  lib,
  inputs,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkMerge mkOption mkEnableOption types genAttrs listToAttrs nameValuePair;
  cfg = config.${namespace}.system.backup.server;
in {
  options.${namespace}.system.backup.server = {
    enable = mkEnableOption "Enable Restic REST Server";
    dataDir = mkOption {
      type = types.str;
      default = "/mnt/extra/Backup";
    };
    port = mkOption {
      type = types.port;
      default = 8069;
    };
    hosts = mkOption {
      type = types.listOf types.str;
      default = ["loki" "thor" "fenrir"];
      description = "Hosts with a private repository at <dataDir>/<host>, pruned server-side.";
    };
    pruneOpts = mkOption {
      type = types.listOf types.str;
      default = ["--keep-daily 7" "--keep-weekly 4" "--keep-monthly 6"];
    };
  };
  config = mkIf cfg.enable {
    age.secrets =
      {
        restic-htpasswd = {
          file = "${inputs.self}/secrets/restic-htpasswd.age";
          owner = "restic";
        };
      }
      # Repository passwords for server-side pruning.
      // genAttrs (map (h: "restic-${h}") cfg.hosts) (name: {
        file = "${inputs.self}/secrets/${name}.age";
        owner = "restic";
      });

    services.restic.server = {
      enable = true;
      inherit (cfg) dataDir;
      listenAddress = "0.0.0.0:${toString cfg.port}";
      htpasswd-file = config.age.secrets.restic-htpasswd.path;
      privateRepos = true;
      # Clients can't delete snapshots; pruning runs locally below.
      appendOnly = true;
    };

    # Weekly local prune per host, as restic so repo files keep their owner.
    services.restic.backups = listToAttrs (map (h:
      nameValuePair "prune-${h}" {
        user = "restic";
        repository = "${cfg.dataDir}/${h}";
        environmentFile = config.age.secrets."restic-${h}".path;
        inherit (cfg) pruneOpts;
        timerConfig = {
          OnCalendar = "Sun 04:00";
          Persistent = true;
        };
      })
    cfg.hosts);

    systemd.services = mkMerge [
      {
        # Don't fill the root filesystem if the backup disk is missing.
        restic-rest-server.unitConfig.RequiresMountsFor = [cfg.dataDir];
      }
      (listToAttrs (map (h:
        nameValuePair "restic-backups-prune-${h}" {
          unitConfig.RequiresMountsFor = [cfg.dataDir];
        })
      cfg.hosts))
    ];

    systemd.tmpfiles.rules = ["d ${cfg.dataDir} 0700 restic restic -"];

    networking.firewall.interfaces = mkIf config.services.tailscale.enable {
      ${config.services.tailscale.interfaceName} = {allowedTCPPorts = [cfg.port];};
    };
  };
}
