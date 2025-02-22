_: {
  imports = [
    ./adguard.nix
    ./audiobookshelf.nix
    ./beszel-hub.nix
    ./caddy.nix
    ./code-server.nix
    ./downloads.nix
    ./flaresolverr.nix
    ./glance.nix
    ./redlib.nix
    ./nfs-server.nix
    ./media-services.nix
    ./immich.nix
    ./overseerr.nix
    ./plex.nix
    ./tautulli.nix
  ];

  services.caddy.virtualHosts = {
    "hoarder.jervw.dev".extraConfig = ''
      reverse_proxy http://127.0.0.1:3020
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
