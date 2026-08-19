{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.services.mediarr;
in {
  options.${namespace}.services.mediarr = {
    enable = mkEnableOption "Enables Radarr, Sonarr, Prowlarr and Bazarr services";
  };

  config = mkIf cfg.enable {
    services = {
      radarr = {
        enable = true;
        settings.server.bindaddress = "127.0.0.1";
      };
      sonarr = {
        enable = true;
        settings.server.bindaddress = "127.0.0.1";
      };
      prowlarr = {
        enable = true;
        settings.server.bindaddress = "127.0.0.1";
      };
      bazarr.enable = true;

      caddy.virtualHosts = {
        "radarr.jervw.dev".extraConfig = ''
          reverse_proxy http://127.0.0.1:7878
          import cloudflare
          import tinyauth
        '';
        "sonarr.jervw.dev".extraConfig = ''
          reverse_proxy http://127.0.0.1:8989
          import cloudflare
          import tinyauth
        '';
        "prowlarr.jervw.dev".extraConfig = ''
          reverse_proxy http://127.0.0.1:9696
          import cloudflare
          import tinyauth
        '';
        "bazarr.jervw.dev".extraConfig = ''
          reverse_proxy http://127.0.0.1:6767
          import cloudflare
          import tinyauth
        '';
      };
    };
    users = {
      users = {
        radarr.extraGroups = ["media"];
        sonarr.extraGroups = ["media"];
        bazarr.extraGroups = ["media"];
      };
    };
  };
}
