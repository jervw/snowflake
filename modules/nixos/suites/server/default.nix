{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkDefault mkEnableOption mkIf;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.suites.server;
in {
  options.${namespace}.suites.server = {
    enable = mkEnableOption "Server common services";
  };

  config = mkIf cfg.enable {
    snowflake = {
      services = {
        adguard = mkDefault enabled;
        audiobookshelf = {
          enable = mkDefault true;
        };
        caddy = mkDefault enabled;
        calibre-web = mkDefault enabled;
        discord-free-game-notifier = mkDefault enabled;
        externals = mkDefault enabled;
        flaresolverr = mkDefault enabled;
        glance = mkDefault enabled;
        immich = mkDefault enabled;
        seerr = mkDefault enabled;
        karakeep = mkDefault enabled;
        mediarr = mkDefault enabled;
        navidrome = mkDefault enabled;
        nfs-server = mkDefault enabled;
        paperless = mkDefault enabled;
        pocket-id = mkDefault enabled;
        plex = mkDefault enabled;
        profilarr = mkDefault enabled;
        qbittorrent = mkDefault enabled;
        tautulli = mkDefault enabled;
        tinyauth = mkDefault enabled;
        wallos = mkDefault enabled;
      };
    };
  };
}
