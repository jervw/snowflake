{config, ...}: {
  services.caddy.virtualHosts."thor.jervw.dev".extraConfig = ''
    reverse_proxy http://thor:7575
    import cloudflare
  '';

  virtualisation.oci-containers.containers = {
    dashy = {
      image = "lissy93/dashy";
      ports = [
        "7575:80"
      ];
      environment = {
        TZ = "${config.time.timeZone}";
        NODE_ENV = "production";
      };
      volumes = [
        "dashy_config:/app/public/conf.yml"
      ];
    };
  };
}
