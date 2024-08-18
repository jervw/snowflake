{
  imports = [
    ./monitoring
    ./adguard.nix
    ./audiobookshelf.nix
    ./caddy.nix
    ./downloads.nix
    ./flaresolverr.nix
    ./immich.nix
    ./redlib.nix
    ./media-services.nix
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
