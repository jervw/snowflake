{
  config,
  inputs,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;

  cfg = config.${namespace}.services.slskd;
  containerUid = config.users.users.containers.uid;
  downloadPath = "${toString cfg.mediaPath}/Soulseek";
  musicPath = "${toString cfg.mediaPath}/Music";
in {
  options.${namespace}.services.slskd = {
    enable = mkEnableOption "slskd routed through Gluetun";

    host = mkOption {
      type = lib.types.str;
      default = "soul.jervw.dev";
      description = "Reverse proxy host name for the slskd web interface";
    };

    webPort = mkOption {
      type = lib.types.port;
      default = 5030;
      description = "Host and container port for the slskd web interface";
    };

    controlPort = mkOption {
      type = lib.types.port;
      default = 20145;
      description = "Host port for the Gluetun control server";
    };

    mediaPath = mkOption {
      type = lib.types.path;
      default = "/mnt/storage/Media";
      description = "Shared media root used by slskd, Aurral, and Lidarr";
    };
  };

  config = mkIf cfg.enable {
    snowflake.virtualisation.quadlet.enable = true;

    age.secrets = {
      gluetun-slskd = {
        file = "${inputs.self}/secrets/gluetun-slskd.age";
        mode = "0400";
        owner = "containers";
        group = "containers";
      };

      gluetun-slskd-auth = {
        file = "${inputs.self}/secrets/gluetun-slskd-auth.age";
        mode = "0400";
        owner = "containers";
        group = "containers";
      };

      slskd = {
        file = "${inputs.self}/secrets/slskd.age";
        mode = "0400";
        owner = "containers";
        group = "containers";
      };
    };

    systemd.services.slskd-directories = {
      description = "Create slskd download directories";
      before = ["slskd.service"];
      unitConfig.RequiresMountsFor = [cfg.mediaPath];
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
      script = ''
        ${pkgs.coreutils}/bin/install -d -m 2770 -o containers -g media \
          ${lib.escapeShellArg downloadPath} \
          ${lib.escapeShellArg "${downloadPath}/complete"} \
          ${lib.escapeShellArg "${downloadPath}/incomplete"}
      '';
    };

    virtualisation.quadlet = let
      inherit (config.virtualisation.quadlet) containers volumes;
    in {
      volumes = {
        slskd-gluetun-data.rootlessConfig.uid = containerUid;
        slskd-config.rootlessConfig.uid = containerUid;
      };

      containers = {
        slskd-gluetun = {
          autoStart = true;
          rootlessConfig.uid = containerUid;

          unitConfig.Upholds = [containers.slskd.ref];

          serviceConfig = {
            Restart = "always";
            RestartSec = "10s";
            TimeoutStartSec = "15min";
          };

          containerConfig = {
            image = "docker.io/qmcgaw/gluetun:latest";
            addCapabilities = ["NET_ADMIN"];
            devices = ["/dev/net/tun:/dev/net/tun"];
            publishPorts = [
              "127.0.0.1:${toString cfg.controlPort}:8000/tcp"
              "127.0.0.1:${toString cfg.webPort}:${toString cfg.webPort}/tcp"
            ];
            environmentFiles = [
              config.age.secrets.gluetun-slskd.path
              config.age.secrets.gluetun-slskd-auth.path
            ];
            environments = {
              GLUETUN_HTTP_CONTROL_SERVER_ENABLE = "on";
              VPN_SERVICE_PROVIDER = "protonvpn";
              VPN_TYPE = "wireguard";
              VPN_PORT_FORWARDING = "on";
              PORT_FORWARD_ONLY = "on";
              SERVER_COUNTRIES = "Netherlands";
            };
            volumes = ["${volumes.slskd-gluetun-data.ref}:/gluetun"];

            healthCmd = "/gluetun-entrypoint healthcheck";
            healthInterval = "5s";
            healthTimeout = "5s";
            healthStartPeriod = "10s";
            healthRetries = 1;
            notify = "healthy";
          };
        };

        slskd = {
          autoStart = true;
          rootlessConfig.uid = containerUid;

          unitConfig = {
            After = [
              containers.slskd-gluetun.ref
              "slskd-directories.service"
            ];
            BindsTo = [containers.slskd-gluetun.ref];
            PartOf = [containers.slskd-gluetun.ref];
            Requires = ["slskd-directories.service"];
            RequiresMountsFor = [cfg.mediaPath];
          };

          serviceConfig = {
            Restart = "always";
            RestartSec = "10s";
          };

          containerConfig = {
            image = "docker.io/slskd/slskd:latest";
            networks = [containers.slskd-gluetun.ref];
            userns = "keep-id:uid=1000,gid=1000";
            addGroups = ["keep-groups"];
            environmentFiles = [
              config.age.secrets.slskd.path
              config.age.secrets.gluetun-slskd-auth.path
            ];
            environments = {
              SLSKD_DOWNLOADS_DIR = "${downloadPath}/complete";
              SLSKD_HTTP_PORT = toString cfg.webPort;
              SLSKD_INCOMPLETE_DIR = "${downloadPath}/incomplete";
              SLSKD_SHARED_DIR = musicPath;
              SLSKD_UMASK = "0002";
              SLSKD_VPN = "true";
              SLSKD_VPN_PORT_FORWARDING = "true";
              SLSKD_VPN_GLUETUN_URL = "http://127.0.0.1:8000";
              TZ = config.time.timeZone;
            };
            volumes = [
              "${volumes.slskd-config.ref}:/app"
              "${toString cfg.mediaPath}:${toString cfg.mediaPath}"
            ];
          };
        };
      };
    };

    services.caddy.virtualHosts."${cfg.host}".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString cfg.webPort}
      import cloudflare
      import tinyauth
    '';
  };
}
