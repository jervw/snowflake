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
        audiobookshelf = mkDefault enabled;
        caddy = mkDefault enabled;
        externals = mkDefault enabled;
        flaresolverr = mkDefault enabled;
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
        speedtest-tracker = mkDefault enabled;
        tautulli = mkDefault enabled;
      };
    };
  };
}
