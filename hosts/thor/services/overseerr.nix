{
  virtualisation.oci-containers.containers.qbittorrent = {
    image = "sctx/overseerr:be047427df62e480fc9b69cb93258837ed72bcf4";
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
