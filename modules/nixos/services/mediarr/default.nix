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

  # TODO: Seperate options for each service?

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
        '';
        "sonarr.jervw.dev".extraConfig = ''
          reverse_proxy http://thor:8989
        '';
        "prowlarr.jervw.dev".extraConfig = ''
          reverse_proxy http://thor:9696
        '';
        "bazarr.jervw.dev".extraConfig = ''
          reverse_proxy http://thor:6767
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
