{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;

  cfg = config.${namespace}.services.aurral;
  containerUid = config.users.users.containers.uid;
in {
  options.${namespace}.services.aurral = {
    enable = mkEnableOption "Aurral music discovery service";

    host = mkOption {
      type = lib.types.str;
      default = "aurral.jervw.dev";
      description = "Reverse proxy host name for Aurral";
    };

    port = mkOption {
      type = lib.types.port;
      default = 3001;
      description = "Host port for Aurral";
    };

    mediaPath = mkOption {
      type = lib.types.path;
      default = "/mnt/storage/Media";
      description = "Shared media root used by Aurral, Lidarr, and download clients";
    };

    dataPath = mkOption {
      type = lib.types.path;
      default = "/var/lib/aurral";
      description = "Host directory for Aurral's database and configuration";
    };
  };

  config = mkIf cfg.enable {
    snowflake.virtualisation.quadlet.enable = true;

    systemd.services.aurral-directories = {
      description = "Create Aurral data directory";
      before = ["aurral.service"];
      unitConfig.RequiresMountsFor = [cfg.dataPath];
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
      script = ''
        ${pkgs.coreutils}/bin/install -d -m 0750 -o containers -g containers \
          ${lib.escapeShellArg (toString cfg.dataPath)}
      '';
    };

    virtualisation.quadlet = {
      containers.aurral = {
        autoStart = true;
        rootlessConfig.uid = containerUid;

        unitConfig = {
          After = ["aurral-directories.service"];
          Requires = ["aurral-directories.service"];
          RequiresMountsFor = [
            cfg.dataPath
            cfg.mediaPath
          ];
        };

        serviceConfig = {
          Restart = "always";
          RestartSec = "10s";
        };

        containerConfig = {
          image = "ghcr.io/lklynet/aurral:latest";
          networks = ["host"];
          userns = "keep-id:uid=1000,gid=1000";
          addGroups = ["keep-groups"];
          environments = {
            PORT = toString cfg.port;
            TZ = config.time.timeZone;
          };
          volumes = [
            "${toString cfg.dataPath}:/config"
            "${toString cfg.mediaPath}:${toString cfg.mediaPath}"
          ];

          healthCmd = "node -e \"fetch('http://127.0.0.1:${toString cfg.port}/api/health/live').then(r=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))\"";
          healthInterval = "30s";
          healthTimeout = "5s";
          healthStartPeriod = "30s";
          healthRetries = 3;
          healthOnFailure = "kill";
        };
      };
    };

    services.caddy.virtualHosts."${cfg.host}".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString cfg.port}
      import cloudflare
    '';
  };
}
