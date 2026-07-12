{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;
  cfg = config.${namespace}.services.paperless;
in {
  options.${namespace}.services.paperless = {
    enable = mkEnableOption "Enable Paperless-NGX service";
    host = mkOption {
      type = lib.types.str;
      default = "paperless.jervw.dev";
      description = "Reverse proxy host name for the Paperless service";
    };
    port = mkOption {
      type = lib.types.number;
      default = 28981;
    };
  };

  config = mkIf cfg.enable {
    services = {
      paperless = {
        enable = true;
        port = cfg.port;
        address = "0.0.0.0";
        domain = cfg.host;
      };

      caddy.virtualHosts."${cfg.host}".extraConfig = ''
        reverse_proxy http://thor:${toString cfg.port}
        import cloudflare
      '';
    };
  };
}
