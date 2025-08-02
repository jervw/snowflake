{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;
  cfg = config.${namespace}.services.monitoring.grafana;
  hostname = config.networking.hostName;
in {
  options.${namespace}.services.monitoring.grafana = {
    enable = mkEnableOption "Enable Grafana service";
    host = mkOption {
      type = lib.types.str;
      default = "metrics.jervw.dev";
      description = "Reverse proxy host name for the Grafana service";
    };
    port = mkOption {
      type = lib.types.number;
      default = 2400;
    };
  };

  config = mkIf cfg.enable {
    services = {
      grafana = {
        enable = true;
        settings = {
          analytics.reporting_enabled = false;
          server = {
            domain = cfg.host;
            http_addr = "0.0.0.0";
            http_port = cfg.port;
          };
        };
      };
      caddy.virtualHosts."${cfg.host}".extraConfig = ''
        reverse_proxy http://${hostname}:${toString cfg.port}
        import cloudflare
      '';
    };
  };
}
