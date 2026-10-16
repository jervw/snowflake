{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.${namespace}.system.backup;
  host = config.networking.hostName;
  dumps = config.services.postgresqlBackup.location;
in {
  # Back up PostgreSQL from a consistent dump instead of the live data dir.
  config = mkIf (cfg.enable && config.services.postgresql.enable) {
    services.postgresqlBackup = {
      enable = true;
      compression = "zstd";
      # Triggered by the restic job below instead of its own timer.
      startAt = [];
    };

    services.restic.backups."daily-${host}" = {
      paths = [dumps];
      # Don't skip the file backup if the dump fails.
      backupPrepareCommand = ''
        systemctl start postgresqlBackup.service || echo "postgresqlBackup failed; backing up previous dump" >&2
      '';
    };
  };
}
