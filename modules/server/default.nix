{
  imports = [
    ./monitoring
    ./adguard.nix
    ./audiobookshelf.nix
    ./caddy.nix
    ./downloads.nix
    ./flaresolverr.nix
    ./redlib.nix
    ./media-services.nix
    ./monero.nix
    ./overseerr.nix
    ./plex.nix
    ./tautulli.nix
  ];

  users.groups.media = {};
  users.users.plex.extraGroups = ["media"];
  users.users.radarr.extraGroups = ["media"];
  users.users.sonarr.extraGroups = ["media"];
}
