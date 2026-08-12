{
  config,
  inputs,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;

  cfg = config.${namespace}.services.qbittorrent;
  containerUid = config.users.users.containers.uid;
in {
  options.${namespace}.services.qbittorrent = {
    enable = mkEnableOption "qBittorrent routed through Gluetun";

    host = mkOption {
      type = lib.types.str;
      default = "dl.jervw.dev";
      description = "Reverse proxy host name for the qBittorrent web interface";
    };

    webPort = mkOption {
      type = lib.types.port;
      default = 8089;
      description = "Host and container port for the qBittorrent web interface";
    };

    controlPort = mkOption {
      type = lib.types.port;
      default = 20144;
      description = "Host port for the Gluetun control server";
    };

    mediaPath = mkOption {
      type = lib.types.path;
      default = "/mnt/storage/Media";
      description = "Host media directory mounted at /files in qBittorrent";
    };

    openFirewall = mkOption {
      type = lib.types.bool;
      default = true;
      description = "Open the qBittorrent and Gluetun control server ports";
    };
  };

  config = mkIf cfg.enable {
    snowflake.virtualisation.quadlet.enable = true;

    age.secrets.gluetun = {
      file = "${inputs.self}/secrets/gluetun.age";
      mode = "0400";
      owner = "containers";
      group = "containers";
    };

    virtualisation.quadlet = let
      inherit (config.virtualisation.quadlet) containers volumes;
    in {
      volumes = {
        gluetun-data.rootlessConfig.uid = containerUid;
        qbittorrent-config.rootlessConfig.uid = containerUid;
      };

      containers = {
        gluetun = {
          autoStart = true;
          rootlessConfig.uid = containerUid;

          unitConfig.Upholds = [containers.qbittorrent.ref];

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
              "${toString cfg.controlPort}:8000/tcp"
              "${toString cfg.webPort}:${toString cfg.webPort}/tcp"
            ];
            environmentFiles = [config.age.secrets.gluetun.path];
            environments = {
              VPN_SERVICE_PROVIDER = "protonvpn";
              VPN_TYPE = "wireguard";
              VPN_PORT_FORWARDING = "on";
              PORT_FORWARD_ONLY = "on";
              SERVER_COUNTRIES = "Netherlands";
              VPN_PORT_FORWARDING_UP_COMMAND = ''/bin/sh -c 'wget -O- --retry-connrefused --post-data "json={\"listen_port\":{{PORT}},\"current_network_interface\":\"{{VPN_INTERFACE}}\",\"random_port\":false,\"upnp\":false}" http://127.0.0.1:${toString cfg.webPort}/api/v2/app/setPreferences 2>&1${"'"}'';
              VPN_PORT_FORWARDING_DOWN_COMMAND = ''/bin/sh -c 'wget -O- --retry-connrefused --post-data "json={\"listen_port\":0,\"current_network_interface\":\"lo\"}" http://127.0.0.1:${toString cfg.webPort}/api/v2/app/setPreferences 2>&1${"'"}'';
            };
            volumes = ["${volumes.gluetun-data.ref}:/gluetun"];

            healthCmd = "/gluetun-entrypoint healthcheck";
            healthInterval = "5s";
            healthTimeout = "5s";
            healthStartPeriod = "10s";
            healthRetries = 1;
            notify = "healthy";
          };
        };

        qbittorrent = {
          autoStart = true;
          rootlessConfig.uid = containerUid;

          unitConfig = {
            After = [containers.gluetun.ref];
            BindsTo = [containers.gluetun.ref];
            PartOf = [containers.gluetun.ref];
          };

          serviceConfig = {
            Restart = "always";
            RestartSec = "10s";
          };

          containerConfig = {
            image = "lscr.io/linuxserver/qbittorrent:latest";
            networks = [containers.gluetun.ref];
            addGroups = ["keep-groups"];
            environments = {
              WEBUI_PORT = toString cfg.webPort;
              PUID = "1000";
              PGID = "1000";
              TZ = "Europe/Helsinki";
            };
            volumes = [
              "${volumes.qbittorrent-config.ref}:/config"
              "${toString cfg.mediaPath}:/files"
              "${pkgs.vuetorrent}/share/vuetorrent:/theme:ro"
            ];
          };
        };
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [
      cfg.controlPort
      cfg.webPort
    ];

    services.caddy.virtualHosts."${cfg.host}".extraConfig = ''
      reverse_proxy http://thor:${toString cfg.webPort}
      import cloudflare
      import tinyauth
    '';
  };
}
