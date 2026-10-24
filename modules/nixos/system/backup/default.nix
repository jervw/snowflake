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
    age.secrets."restic-${host}".file = "${inputs.self}/secrets/restic-${host}.age";
    services.restic.backups."daily-${host}" = {
      initialize = true;
      # privateRepos requires the repository path to start with the REST
      # username (the hostname). Credentials come from the environment file.
      repository = "rest:http://${cfg.serverAddress}/${host}";
      environmentFile = config.age.secrets."restic-${host}".path;
      inherit (cfg) paths;
      exclude = globalExcludes ++ cfg.exclude;
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };
      # The server is append-only; pruning runs on the server.
      checkOpts = ["--with-cache"];
    };
  };
}
