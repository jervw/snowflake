{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) escapeShellArg escapeShellArgs mkIf mkMerge mkOption types;
  cfg = config.${namespace}.system.backup;
  host = config.networking.hostName;
  sqliteDumps = "/var/backup/sqlite";
in {
  options.${namespace}.system.backup.sqliteDirs = mkOption {
    type = types.listOf types.path;
    default = [];
    description = ''
      Directories searched for SQLite databases. Before each backup, every
      database is copied with the SQLite backup API to ${sqliteDumps}/<path>,
      since a plain file copy of a live database can be inconsistent.
    '';
  };

  config = mkIf cfg.enable (mkMerge [
    # Back up PostgreSQL from a consistent dump instead of the live data dir.
    (mkIf config.services.postgresql.enable {
      services.postgresqlBackup = {
        enable = true;
        compression = "zstd";
        # Started by the backup job instead of its own timer.
        startAt = [];
      };

      ${namespace}.system.backup.prepareUnits = ["postgresqlBackup.service"];

      services.restic.backups."daily-${host}" = {
        paths = [config.services.postgresqlBackup.location];
        # A file copy of a running cluster may not be restorable; the dump is.
        exclude = [config.services.postgresql.dataDir];
      };
    })

    (mkIf (cfg.sqliteDirs != []) {
      systemd.tmpfiles.rules = ["d ${sqliteDumps} 0700 root root -"];

      systemd.services.backup-sqlite = {
        description = "Copy SQLite databases for backup";
        path = with pkgs; [coreutils findutils sqlite];
        serviceConfig = {
          Type = "oneshot";
          UMask = "0077";
          PrivateNetwork = true;
          PrivateTmp = true;
          ProtectSystem = "strict";
          # SQLite may create a -shm file next to a database that isn't open.
          ReadWritePaths = [sqliteDumps] ++ cfg.sqliteDirs;
        };
        script = ''
          dest=${escapeShellArg sqliteDumps}
          staging="$dest/.staging.db"
          failed=0

          # The find below skips container image layers, which ship package databases.
          while IFS= read -r -d "" db; do
            [ "$(head -c 15 "$db" | tr -d '\0')" = "SQLite format 3" ] || continue
            rm -f "$staging"
            # Read-only, so the live database is never checkpointed or modified.
            if sqlite3 -readonly -cmd ".timeout 30000" "$db" ".backup '$staging'"; then
              mkdir -p "$(dirname "$dest$db")"
              mv -f "$staging" "$dest$db"
            else
              echo "Failed to copy $db" >&2
              failed=1
            fi
          done < <(find ${escapeShellArgs cfg.sqliteDirs} \
            -path '*/containers/storage/*' ! -path '*/containers/storage/volumes*' -prune \
            -o -type f \( -name '*.db' -o -name '*.sqlite' -o -name '*.sqlite3' \) -print0)

          # Drop copies whose database no longer exists.
          while IFS= read -r -d "" copy; do
            [ -e "''${copy#"$dest"}" ] || rm -f "$copy"
          done < <(find "$dest" -type f ! -name .staging.db -print0)
          find "$dest" -mindepth 1 -type d -empty -delete

          exit "$failed"
        '';
      };

      ${namespace}.system.backup.prepareUnits = ["backup-sqlite.service"];
      services.restic.backups."daily-${host}".paths = [sqliteDumps];
    })
  ]);
}
