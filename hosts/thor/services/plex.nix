{
  services.plex = {
    enable = true;
  };

  # Reverse proxy
  services.nginx.virtualHosts = {
    "plex.jervw.dev" = {
      forceSSL = true;
      sslCertificate = "/var/ssl/jervw.dev.cert";
      sslCertificateKey = "/var/ssl/jervw.dev.key";
      locations."/" = {
        proxyPass = "http://127.0.0.1:32400";
        proxyWebsockets = true;
      };
    };
  };
}
