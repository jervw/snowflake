{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;
  cfg = config.${namespace}.services.jellyseerr;
in {
  options.${namespace}.services.jellyseerr = {
    enable = mkEnableOption "Enable Jellyseerr service";
    host = mkOption {
      type = lib.types.str;
      default = "seerr.jervw.dev";
      description = "Reverse proxy host name for the Jellyseerr service";
    };
  };

  # TODO: Add port configuration

  config = mkIf cfg.enable {
    services = {
      jellyseerr = {
        enable = true;
        openFirewall = true;
      };
      services.caddy.virtualHosts."${cfg.host}".extraConfig = ''
        reverse_proxy http://thor:5055
        import cloudflare
      '';
    };
  };
}
