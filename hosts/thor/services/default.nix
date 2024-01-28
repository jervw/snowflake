{
  imports = [
    ./torrent.nix
    ./adguard.nix
    ./plex.nix
    ./media-services.nix
    ./overseerr.nix
    ./audiobookshelf.nix
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

  users.groups.media = {};
  users.users.plex.extraGroups = ["media"];
  users.users.radarr.extraGroups = ["media"];
  users.users.sonarr.extraGroups = ["media"];
}
