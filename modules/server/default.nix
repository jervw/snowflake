{
  imports = [
    ./monitoring
    ./adguard.nix
    ./audiobookshelf.nix
    ./caddy.nix
    ./containers.nix
    ./downloads.nix
    ./flaresolverr.nix
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
