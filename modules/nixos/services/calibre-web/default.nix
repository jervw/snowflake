{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;

  cfg = config.${namespace}.services.calibre-web;
  containerUid = config.users.users.containers.uid;
in {
  options.${namespace}.services.calibre-web = {
    enable = mkEnableOption "Calibre-Web Automated service";

    host = mkOption {
      type = lib.types.str;
      default = "calibre.jervw.dev";
      description = "Reverse proxy host name for Calibre-Web Automated";
    };

    port = mkOption {
      type = lib.types.port;
      default = 8083;
      description = "Host and container port for Calibre-Web Automated";
    };

    openFirewall = mkOption {
      type = lib.types.bool;
      default = true;
      description = "Open the web port for direct access from the local network";
    };

    libraryPath = mkOption {
      type = lib.types.path;
      default = "/mnt/storage/Media/Books/Books-Jervw";
      description = "Existing Calibre library mounted at /calibre-library";
    };

    ingestPath = mkOption {
      type = lib.types.path;
      default = "/mnt/storage/Media/Books/CWA-Ingest";
      description = "Book ingest directory; CWA removes files after processing them";
    };

    networkShareMode = mkOption {
      type = lib.types.bool;
      default = false;
      description = "Disable SQLite WAL and use polling for a library on NFS or SMB storage";
    };
  };

  config = mkIf cfg.enable {
    snowflake.virtualisation.quadlet.enable = true;

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [cfg.port];

    systemd.tmpfiles.rules = [
      "d ${toString cfg.ingestPath} 2770 containers media -"
    ];

    virtualisation.quadlet = let
      inherit (config.virtualisation.quadlet) volumes;
    in {
      volumes.calibre-web-config.rootlessConfig.uid = containerUid;

      containers.calibre-web = {
        autoStart = true;
        rootlessConfig.uid = containerUid;

        unitConfig.RequiresMountsFor = [
          cfg.libraryPath
          cfg.ingestPath
        ];

        serviceConfig = {
          Restart = "always";
          RestartSec = "10s";
          TimeoutStartSec = "10min";
        };

        containerConfig = {
          image = "docker.io/crocodilestick/calibre-web-automated:latest";
          pull = "newer";
          userns = "keep-id:uid=1000,gid=1000";
          addGroups = ["keep-groups"];

          publishPorts = [
            "${
              if cfg.openFirewall
              then "0.0.0.0"
              else "127.0.0.1"
            }:${toString cfg.port}:${toString cfg.port}/tcp"
          ];

          environments = {
            PUID = "1000";
            PGID = "1000";
            TZ = config.time.timeZone;
            CWA_PORT_OVERRIDE = toString cfg.port;
            NETWORK_SHARE_MODE = lib.boolToString cfg.networkShareMode;
          };

          volumes = [
            "${volumes.calibre-web-config.ref}:/config"
            "${toString cfg.ingestPath}:/cwa-book-ingest"
            "${toString cfg.libraryPath}:/calibre-library"
          ];

          healthCmd = "curl -f http://localhost:${toString cfg.port}/ || curl -f -k https://localhost:${toString cfg.port}/ || exit 1";
          healthInterval = "30s";
          healthTimeout = "3s";
          healthStartPeriod = "120s";
          healthRetries = 3;
          healthOnFailure = "kill";
          notify = "healthy";
        };
      };
    };

    services.caddy.virtualHosts."${cfg.host}".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString cfg.port}
      import cloudflare
    '';
  };
}
