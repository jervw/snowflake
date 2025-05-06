_: {
  imports = [
    ./adguard.nix
    ./audiobookshelf.nix
    ./beszel-hub.nix
    ./caddy.nix
    ./downloads.nix
    ./flaresolverr.nix
    ./glance.nix
    ./homepage.nix
    ./redlib.nix
    ./nfs-server.nix
    ./media-services.nix
    ./immich.nix
    ./jellyseerr.nix
    ./plex.nix
    ./tautulli.nix
  ];

  services.caddy.virtualHosts = {
    "hoarder.jervw.dev".extraConfig = ''
      reverse_proxy http://127.0.0.1:3020
      import cloudflare
    '';
    "profilarr.jervw.dev".extraConfig = ''
      reverse_proxy http://127.0.0.1:6868
      import cloudflare
    '';
    "speedtest.jervw.dev".extraConfig = ''
      reverse_proxy http://127.0.0.1:8095
      import cloudflare
    '';
  };

  users = {
    groups.media = {};
    users = {
      plex.extraGroups = ["media"];
      radarr.extraGroups = ["media"];
      sonarr.extraGroups = ["media"];
    };
  };
}
