{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;
  cfg = config.${namespace}.services.adguard;
in {
  options.${namespace}.services.calibre-web = {
    enable = mkEnableOption "Enable Calibre-Web service";
    host = mkOption {
      type = lib.types.str;
      default = "calibre.jervw.dev";
      description = "Reverse proxy host name for the Calibre-Web service";
    };
    port = mkOption {
      type = lib.types.number;
      default = 8231;
    };
  };

  config = mkIf cfg.enable {
    services = {
      calibre-web = {
        enable = true;
        openFirewall = true;
        listen = {
          ip = "0.0.0.0";
          port = cfg.port;
        };
        options = {
          calibreLibrary = "/mnt/storage/NAS/Books/Books/Books-Jervw";
        };
      };

      caddy.virtualHosts."${cfg.host}".extraConfig = ''
        reverse_proxy http://thor:${toString cfg.port}
        import cloudflare
      '';
    };
  };
}
