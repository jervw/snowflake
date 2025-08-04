{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;
  cfg = config.${namespace}.services.audiobookshelf;
in {
  options.${namespace}.services.audiobookshelf = {
    enable = mkEnableOption "Enable Audiobookshelf service";
    host = mkOption {
      type = lib.types.str;
      default = "shelf.jervw.dev";
      description = "Reverse proxy host name for the Audiobookshelf service";
    };
    port = mkOption {
      type = lib.types.number;
      default = 8000;
    };
  };

  config = mkIf cfg.enable {
    services = {
      audiobookshelf = {
        enable = true;
        openFirewall = true;
        host = "0.0.0.0";
        port = cfg.port;
      };
      caddy.virtualHosts."${cfg.host}".extraConfig = ''
        reverse_proxy http://thor:${toString cfg.port}
      '';
    };
  };
}
