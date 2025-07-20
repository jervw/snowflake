{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;
  cfg = config.${namespace}.services.torrent;
in {
  options.${namespace}.services.torrent = {
    enable = mkEnableOption "Enable qBittorrent proxy service";
    host = mkOption {
      type = lib.types.str;
      default = "dl.jervw.dev";
      description = "Reverse proxy host name for the qBittorrent proxy service";
    };
  };

  # TODO: Move to OCI-container, or seek an alternative with VPN isolation

  config = mkIf cfg.enable {
    services = {
      caddy.virtualHosts."${cfg.host}".extraConfig = ''
        reverse_proxy http://thor:8080
        import cloudflare
      '';
    };
  };
}
