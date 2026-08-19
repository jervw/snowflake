{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;
  cfg = config.${namespace}.services.immich;
in {
  options.${namespace}.services.immich = {
    enable = mkEnableOption "Enable Immich service";
    host = mkOption {
      type = lib.types.str;
      default = "media.jervw.dev";
      description = "Reverse proxy host name for the Immich service";
    };
    port = mkOption {
      type = lib.types.number;
      default = 2995;
    };
  };

  config = mkIf cfg.enable {
    services = {
      immich = {
        enable = true;
        mediaLocation = "/mnt/storage/Immich-Library";
        group = "media";
        host = "127.0.0.1";
        inherit (cfg) port;
      };
      caddy.virtualHosts."${cfg.host}".extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString cfg.port}
        import cloudflare
      '';
    };
  };
}
