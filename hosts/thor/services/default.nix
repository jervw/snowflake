{
  imports = [
    ./adguard.nix
    ./plex.nix
    ./media-services.nix
    ./overseerr.nix
    ./samba.nix
  ];

  networking.firewall.allowedTCPPorts = [80 443];
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;

    virtualHosts = {
      "fallback.default" = {
        default = true;
        locations."/".extraConfig = "return 444;";
      };

      "jervw.dev" = {
        forceSSL = true;
        sslCertificate = "/var/ssl/jervw.dev.cert";
        sslCertificateKey = "/var/ssl/jervw.dev.key";
        locations."/" = {
          proxyPass = "https://jervw.github.io";
          extraConfig = "proxy_ssl_server_name on;";
        };
      };
    };
  };
}
