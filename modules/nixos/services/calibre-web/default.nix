{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;
  cfg = config.${namespace}.services.calibre-web;
in {
  options.${namespace}.services.calibre-web = {
    enable = mkEnableOption "Enable Calibre-web service";
    host = mkOption {
      type = lib.types.str;
      default = "calibre.jervw.dev";
      description = "Reverse proxy host name for the Calibre-web service";
    };
    port = mkOption {
      type = lib.types.number;
      default = 8083;
    };
  };

  config = mkIf cfg.enable {
    services = {
      calibre-web = {
        enable = true;

        listen = {
          ip = "127.0.0.1";
          inherit (cfg) port;
        };

        options = {
          calibreLibrary = "/mnt/storage/Media/Books/Books-Jervw";
          enableBookUploading = true;
          enableKepubify = true;
        };
      };
      caddy.virtualHosts."${cfg.host}".extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString cfg.port}
        import cloudflare
      '';
    };
  };
}
