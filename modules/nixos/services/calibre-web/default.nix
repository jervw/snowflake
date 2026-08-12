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
        openFirewall = true;

        listen = {
          ip = "0.0.0.0";
          inherit (cfg) port;
        };

        options = {
          calibreLibrary = "/mnt/storage/Media/Books/Books-Jervw";
          enableBookUploading = true;
          enableKepubify = true;
        };
      };
      caddy.virtualHosts."${cfg.host}".extraConfig = ''
        reverse_proxy http://thor:${toString cfg.port}
        import cloudflare
      '';
    };
  };
}
