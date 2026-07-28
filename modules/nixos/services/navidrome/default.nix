{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;
  cfg = config.${namespace}.services.navidrome;
in {
  options.${namespace}.services.navidrome = {
    enable = mkEnableOption "Enable Navidrome service";
    host = mkOption {
      type = lib.types.str;
      default = "music.jervw.dev";
      description = "Reverse proxy host name for the Navidrome service";
    };
    port = mkOption {
      type = lib.types.number;
      default = 4533;
    };
  };
  config = mkIf cfg.enable {
    services = {
      navidrome = {
        enable = true;
        settings = {
          MusicFolder = "/mnt/storage/Media/Music";
          BaseUrl = "https://" + cfg.host;
          Address = "0.0.0.0";
          Port = cfg.port;
        };
      };
      caddy.virtualHosts."${cfg.host}".extraConfig = ''
        reverse_proxy http://thor:${toString cfg.port}
        import cloudflare
      '';
    };
  };
}
