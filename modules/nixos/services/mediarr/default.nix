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
        openFirewall = true;
      };
      sonarr = {
        enable = true;
        openFirewall = true;
      };
      prowlarr = {
        enable = true;
        openFirewall = true;
      };
      bazarr = {
        enable = true;
        openFirewall = true;
      };

      caddy.virtualHosts = {
        "radarr.jervw.dev".extraConfig = ''
          reverse_proxy http://thor:7878
          import cloudflare
        '';
        "sonarr.jervw.dev".extraConfig = ''
          reverse_proxy http://thor:8989
          import cloudflare
        '';
        "prowlarr.jervw.dev".extraConfig = ''
          reverse_proxy http://thor:9696
          import cloudflare
        '';
        "bazarr.jervw.dev".extraConfig = ''
          reverse_proxy http://thor:6767
          import cloudflare
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
