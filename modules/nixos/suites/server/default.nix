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
        beszel.server = mkDefault enabled;
        adguard = mkDefault enabled;
        audiobookshelf = mkDefault enabled;
        caddy = mkDefault enabled;
        flaresolverr = mkDefault enabled;
        gatus = mkDefault enabled;
        glance = mkDefault enabled;
        immich = mkDefault enabled;
        jellyfin = mkDefault enabled;
        jellyseerr = mkDefault enabled;
        karakeep = mkDefault enabled;
        logind = mkDefault enabled;
        mediarr = mkDefault enabled;
        nfs-server = mkDefault enabled;
        plex = mkDefault enabled;
        profilarr = mkDefault enabled;
        redlib = mkDefault enabled;
        speedtest-tracker = mkDefault enabled;
        tautulli = mkDefault enabled;
        torrent = mkDefault enabled;
      };
    };
  };
}
