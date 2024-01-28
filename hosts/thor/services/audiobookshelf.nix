{
  services.audiobookshelf = {
    enable = true;
  };

  # Reverse proxy
  services.nginx.virtualHosts = {
    "shelf.jervw.dev" = {
      forceSSL = true;
      sslCertificate = "/var/ssl/jervw.dev.cert";
      sslCertificateKey = "/var/ssl/jervw.dev.key";
      locations."/" = {
        proxyPass = "http://127.0.0.1:8000";
        proxyWebsockets = true;
      };
    };
  };
}
