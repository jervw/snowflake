{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;
  cfg = config.${namespace}.services.gatus;
in {
  options.${namespace}.services.gatus = {
    enable = mkEnableOption "Enable Gatus service";
    host = mkOption {
      type = lib.types.str;
      default = "status.jervw.dev";
      description = "Reverse proxy host name for the Gatus service";
    };
    port = mkOption {
      type = lib.types.number;
      default = 8083;
    };
  };

  config = mkIf cfg.enable {
    services = {
      gatus = {
        enable = true;
        openFirewall = true;
        settings = {
          web.port = cfg.port;
          endpoints = [
            {
              name = "AdGuardHome";
              url = "https://dns.jervw.dev";
              interval = "1m";
              conditions = [
                "[STATUS] == 200"
                "[RESPONSE_TIME] < 300"
              ];
            }
            {
              name = "Audiobookshelf";
              url = "https://shelf.jervw.dev";
              interval = "1m";
              conditions = [
                "[STATUS] == 200"
                "[RESPONSE_TIME] < 300"
              ];
            }
            {
              name = "qBittorrent";
              url = "https://dl.jervw.dev";
              interval = "1m";
              conditions = [
                "[STATUS] == 200"
                "[RESPONSE_TIME] < 300"
              ];
            }
            {
              name = "qBittorrent";
              url = "https://dl.jervw.dev";
              interval = "1m";
              conditions = [
                "[STATUS] == 200"
                "[RESPONSE_TIME] < 300"
              ];
            }
          ];
        };
      };

      caddy.virtualHosts."${cfg.host}".extraConfig = ''
        reverse_proxy http://thor:${toString cfg.port}
        import cloudflare
      '';
    };
  };
}
