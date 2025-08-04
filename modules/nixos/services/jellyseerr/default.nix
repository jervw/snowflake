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
    port = mkOption {
      type = lib.types.number;
      default = 5055;
    };
  };

  config = mkIf cfg.enable {
    services = {
      jellyseerr = {
        enable = true;
        openFirewall = true;
        port = cfg.port;
      };
      caddy.virtualHosts."${cfg.host}".extraConfig = ''
        reverse_proxy http://thor:${toString cfg.port}
      '';
    };
  };
}
