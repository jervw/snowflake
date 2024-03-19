{
  services.caddy.virtualHosts."thor.jervw.dev".extraConfig = ''
    reverse_proxy http://thor:7575
    import cloudflare
  '';

  virtualisation.oci-containers.containers.homarr = {
    image = "ghcr.io/ajnart/homarr:latest";
    ports = [
      "7575:7575"
    ];
    volumes = [
      "/var/run/docker.sock:/var/run/docker.sock"
      "homarr_configs:/app/data/configs"
      "homarr_icons:/app/public/icons"
      "homarr_data:/data"
    ];
  };
}
