{
  config,
  lib,
  inputs,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkOption mkEnableOption types;
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
  };
  config = mkIf cfg.enable {
    age.secrets.restic.file = "${inputs.self}/secrets/restic.age";
    services.restic.server = {
      enable = true;
      inherit (cfg) dataDir;
      listenAddress = "0.0.0.0:${toString cfg.port}";
      htpasswd-file = "/run/restic/htpasswd";
      privateRepos = true;
    };

    systemd.services.restic-htpasswd-setup = {
      description = "Setup Restic htpasswd file";
      after = ["agenix.service"];
      before = ["restic-rest-server.service"];
      wantedBy = ["restic-rest-server.service"];
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
      script = let
        htpasswdPath = "${config.age.secrets.restic.path}";
      in ''
        mkdir -p /run/restic
        grep '^HTPASSWD_ENTRY=' '${htpasswdPath}' | cut -d= -f2- > /run/restic/htpasswd
        chmod 400 /run/restic/htpasswd
        chown restic:restic /run/restic/htpasswd
      '';
    };

    systemd.services.restic-rest-server = {
      requires = ["restic-htpasswd-setup.service"];
      after = ["restic-htpasswd-setup.service"];
    };

    systemd.tmpfiles.rules = ["d ${cfg.dataDir} 0700 restic restic -"];
  };
}
