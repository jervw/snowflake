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
    ./invidious.nix
    ./immich.nix
    ./jellyfin.nix
    ./jellyseerr.nix
    ./overseerr.nix
    ./plex.nix
    ./tautulli.nix
  ];

  users = {
    groups.media = {};
    users = {
      plex.extraGroups = ["media"];
      radarr.extraGroups = ["media"];
      sonarr.extraGroups = ["media"];
    };
  };
}
