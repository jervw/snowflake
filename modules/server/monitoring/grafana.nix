{config, ...}: {
  services.caddy.virtualHosts."monitoring.jervw.dev".extraConfig = ''
    reverse_proxy http://0.0.0.0:2400
    import cloudflare
  '';

  services.grafana = {
    enable = true;
    settings = {
      analytics.reporting_enabled = false;

      server = {
        domain = "monitoring.jervw.dev";
        http_addr = "0.0.0.0";
        http_port = 2400;
      };
    };

    provision.datasources.settings.datasources = [
      {
        name = "Prometheus";
        type = "prometheus";
        access = "proxy";
        url = "http://127.0.0.1:${toString config.services.prometheus.port}";
      }
      {
        name = "Loki";
        type = "loki";
        access = "proxy";
        url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}";
      }
    ];
  };
}
