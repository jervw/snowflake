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
      networking.fail2ban = mkDefault enabled;
      services = {
        adguard = mkDefault enabled;
        audiobookshelf = mkDefault enabled;
        beszel = mkDefault enabled;
        caddy = mkDefault enabled;
        flaresolverr = mkDefault enabled;
        glance = mkDefault enabled;
        immich = mkDefault enabled;
        jellyseerr = mkDefault enabled;
        karakeep = mkDefault enabled;
        logind = mkDefault enabled;
        mediarr = mkDefault enabled;
        nfs-server = mkDefault enabled;
        plex = mkDefault enabled;
        redlib = mkDefault enabled;
        tautulli = mkDefault enabled;
        torrent = mkDefault enabled;
      };
    };
  };
}
