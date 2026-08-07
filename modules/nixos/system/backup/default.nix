{
  config,
  lib,
  inputs,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkOption mkEnableOption types;
  cfg = config.${namespace}.system.backup;
  host = config.networking.hostName;
  globalExcludes = import ./excludes.nix;
in {
  options.${namespace}.system.backup = {
    enable = mkEnableOption "Enable backups with Restic";
    serverAddress = mkOption {
      type = types.str;
      default = "thor:8069";
      description = "The address of the REST server.";
    };
    paths = mkOption {
      type = types.listOf types.path;
      default = [];
      description = "Paths to backup.";
    };
    exclude = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Patterns or paths to exclude from the backup.";
      example = ["/home/*/.cache" ".git"];
    };
  };
  config = mkIf cfg.enable {
    age.secrets.restic-password.file = "${inputs.self}/secrets/restic.age";
    services.restic.backups."daily-${host}" = {
      initialize = true;
      # privateRepos requires the repository path to start with the REST
      # username. Authentication is supplied through the environment file.
      repository = "rest:http://${cfg.serverAddress}/backup/${host}";
      environmentFile = config.age.secrets.restic-password.path;
      paths = cfg.paths;
      exclude = globalExcludes ++ cfg.exclude;
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };
      pruneOpts = ["--keep-daily 7" "--keep-weekly 4" "--keep-monthly 6"];
    };
  };
}
