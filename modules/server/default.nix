{
  imports = [
    ./adguard.nix
    ./audiobookshelf.nix
    ./caddy.nix
    ./downloads.nix
    ./flaresolverr.nix
    ./glance.nix
    ./redlib.nix
    ./media-services.nix
    ./immich.nix
    ./jellyfin.nix
    ./jellyseerr.nix
    ./overseerr.nix
    ./plex.nix
    ./tautulli.nix
  ];

  services.caddy.virtualHosts."dawarich.jervw.dev".extraConfig = ''
    reverse_proxy http://127.0.0.1:3011
    import cloudflare
  '';

  users = {
    groups.media = {};
    users = {
      plex.extraGroups = ["media"];
      radarr.extraGroups = ["media"];
      sonarr.extraGroups = ["media"];
    };
  };
}
