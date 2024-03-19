{
  imports = [
    ./adguard.nix
    ./caddy.nix
    ./plex.nix
    ./media-services.nix
    ./overseerr.nix
    ./audiobookshelf.nix
    ./homarr.nix
  ];

  users.groups.media = {};
  users.users.plex.extraGroups = ["media"];
  users.users.radarr.extraGroups = ["media"];
  users.users.sonarr.extraGroups = ["media"];
}
