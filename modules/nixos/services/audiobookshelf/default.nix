{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;
  cfg = config.${namespace}.services.audiobookshelf;
in {
  options.${namespace}.services.audiobookshelf = {
    enable = mkEnableOption "Enable Audiobookshelf service";
    host = mkOption {
      type = lib.types.str;
      default = "shelf.jervw.dev";
      description = "Reverse proxy host name for the Audiobookshelf service";
    };
  };

  # TODO: Add port configuration

  config = mkIf cfg.enable {
    services = {
      audiobookshelf.enable = true;
      caddy.virtualHosts."${cfg.host}".extraConfig = ''
        reverse_proxy http://thor:8000
        import cloudflare
      '';
    };
  };
}
