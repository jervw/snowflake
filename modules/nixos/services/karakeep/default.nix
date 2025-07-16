{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;
  cfg = config.${namespace}.services.karakeep;
in {
  options.${namespace}.services.karakeep = {
    enable = mkEnableOption "Enable Karakeep service";
    host = mkOption {
      type = lib.types.str;
      default = "save.jervw.dev";
      description = "Reverse proxy host name for the Karakeep service";
    };
    port = mkOption {
      type = lib.types.number;
      default = 3020;
    };
  };

  config = mkIf cfg.enable {
    services = {
      karakeep = {
        enable = true;
        extraEnvironment = {
          PORT = "${toString cfg.port}";
          CRAWLER_FULL_PAGE_SCREENSHOT = "true";
          CRAWLER_FULL_PAGE_ARCHIVE = "true";
          CRAWLER_VIDEO_DOWNLOAD = "true";
        };
      };
      caddy.virtualHosts."${cfg.host}".extraConfig = ''
        reverse_proxy http://thor:${toString cfg.port}
        import cloudflare
      '';
    };
  };
}
