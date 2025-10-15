{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;
  cfg = config.${namespace}.services.speedtest-tracker;
in {
  options.${namespace}.services.speedtest-tracker = {
    enable = mkEnableOption "Enable speedtest-tracker service";
    host = mkOption {
      type = lib.types.str;
      default = "speedtest.jervw.dev";
      description = "Reverse proxy host name for the speedtest-tracker service";
    };
    port = mkOption {
      type = lib.types.number;
      default = 8095;
    };
    dataDir = mkOption {
      type = lib.types.path;
      default = "/var/lib/speedtest-tracker";
      description = "Directory for Speedtest Tracker config volume.";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers.speedtest-tracker = {
      image = "lscr.io/linuxserver/speedtest-tracker:latest";
      ports = ["${toString cfg.port}:80"];
      environment = {
        PUID = "1000";
        PGID = "1000";
        APP_NAME = "Koti13";
        APP_KEY = "base64:7VRM1BvGFOEboilhlmaapxmsWmIaP0cXEuz0g59+VRo="; # Not that secret to be a secret
        APP_URL = "https://${cfg.host}";
        ASSET_URL = "https://${cfg.host}";
        DB_CONNECTION = "sqlite";
        SPEEDTEST_SCHEDULE = "0 * * * *";
        SPEEDTEST_SERVERS = "56225,32643,31122";
        APP_TIMEZONE = "Europe/Helsinki";
      };
      volumes = [
        "${cfg.dataDir}:/config"
      ];
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0755 1000 1000 - -"
    ];

    services.caddy.virtualHosts."${cfg.host}".extraConfig = ''
      reverse_proxy http://thor:${toString cfg.port}
      import cloudflare
    '';
  };
}
