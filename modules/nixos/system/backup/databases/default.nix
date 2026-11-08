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
      # Started by the backup job instead of its own timer.
      startAt = [];
    };

    ${namespace}.system.backup.prepareUnits = ["postgresqlBackup.service"];

    services.restic.backups."daily-${host}" = {
      paths = [dumps];
    };
  };
}
