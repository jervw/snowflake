{
  imports = [
    ./monitoring
    ./adguard.nix
    ./audiobookshelf.nix
    ./caddy.nix
    ./downloads.nix
    ./flaresolverr.nix
    ./dashy.nix
    ./media-services.nix
    ./overseerr.nix
    ./plex.nix
    ./tautulli.nix
  ];

  users.groups.media = {};
  users.users.plex.extraGroups = ["media"];
  users.users.radarr.extraGroups = ["media"];
  users.users.sonarr.extraGroups = ["media"];
}
