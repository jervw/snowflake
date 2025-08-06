{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types mapAttrsToList;

  cfg = config.${namespace}.services.monitoring.grafana;
  hostname = config.networking.hostName;

  exporterPorts = {
    node = config.services.prometheus.exporters.node.port;
    zfs = config.services.prometheus.exporters.zfs.port;
    blackbox = config.services.prometheus.exporters.blackbox.port;
    cadvisor = config.services.cadvisor.port;
  };

  # Dynamically build scrapeConfigs from targets and ports
  scrapeConfigs =
    mapAttrsToList (
      jobName: hosts: let
        port = exporterPorts.${jobName}
        or (throw "Unknown or unsupported exporter '${jobName}'. Add it to exporterPorts.");
      in {
        job_name = jobName;
        static_configs = [
          {targets = map (host: "${host}:${toString port}") hosts;}
        ];
      }
    )
    cfg.scrapeTargets;
in {
  options.${namespace}.services.monitoring.grafana = {
    enable = mkEnableOption "Enable Grafana and Prometheus monitoring stack";

    host = mkOption {
      type = types.str;
      default = "monitor.jervw.dev";
      description = "Reverse proxy host name for the Grafana service";
    };

    port = mkOption {
      type = types.port;
      default = 2400;
      description = "Local port Grafana listens on";
    };

    scrapeTargets = mkOption {
      type = types.attrsOf (types.listOf types.str);
      default = {};
      description = "Map of Prometheus exporter job names to list of hosts";
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
            root_url = "https://${cfg.host}";
          };
        };
        provision.datasources.settings.datasources = [
          {
            name = "Prometheus";
            type = "prometheus";
            access = "proxy";
            url = "http://127.0.0.1:9090";
          }
        ];
      };

      prometheus = {
        enable = true;
        inherit scrapeConfigs;
      };

      caddy.virtualHosts."${cfg.host}".extraConfig = ''
        reverse_proxy http://${hostname}:${toString cfg.port}
      '';
    };
  };
}
