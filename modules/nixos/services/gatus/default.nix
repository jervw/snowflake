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
              name = "test";
              url = "https://google.com";
              interval = "5m";
              conditions = [
                "[STATUS] == 200"
                "[BODY].status == UP"
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
