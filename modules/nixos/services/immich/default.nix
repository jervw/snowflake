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
  };

  # TODO: Add port configuration

  config = mkIf cfg.enable {
    services = {
      immich = {
        enable = true;
        openFirewall = true;
        mediaLocation = "/mnt/storage/Immich-Library";
        group = "media";
        host = "0.0.0.0";
        port = 2995;
      };
      services.caddy.virtualHosts."${cfg.host}".extraConfig = ''
        reverse_proxy http://thor:2995
        import cloudflare
      '';
    };
  };
}
