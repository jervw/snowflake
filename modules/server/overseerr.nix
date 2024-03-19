{
  services.caddy.virtualHosts."seerr.jervw.dev".extraConfig = ''
    reverse_proxy http://thor:5055
    import cloudflare
  '';

  virtualisation.oci-containers.containers.overseerr = {
    image = "sctx/overseerr";
    ports = [
      "5055:5055"
    ];
    environment = {
      PORT = "5055";
    };
    volumes = [
      "overseerr_config:/app/config"
    ];
  };
}
