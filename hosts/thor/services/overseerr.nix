{
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

  services.nginx.virtualHosts."seerr.jervw.dev" = {
    forceSSL = true;
    sslCertificate = "/var/ssl/jervw.dev.cert";
    sslCertificateKey = "/var/ssl/jervw.dev.key";
    locations."/".proxyPass = "http://127.0.0.1:5055";
  };
}
