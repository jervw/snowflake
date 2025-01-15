_: {
  virtualisation.oci-containers.containers.flaresolverr = {
    image = "ghcr.io/flaresolverr/flaresolverr";
    ports = [
      "8191:8191"
    ];
    environment = {
      LOG_LEVEL = "info";
      TZ = "Europe/Helsinki";
    };
  };
}
