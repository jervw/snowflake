{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.services.externals;
in {
  options.${namespace}.services.externals = {
    enable = mkEnableOption "Enable reverse proxy for non NixOS services";
  };

  config = mkIf cfg.enable {
    services.caddy.virtualHosts = {
      # QBitTorrent
      "dl.jervw.dev".extraConfig = ''
        reverse_proxy http://thor:8080
        import cloudflare
      '';

      # YamTrack
      "track.jervw.dev".extraConfig = ''
        reverse_proxy http://thor:8001
        import cloudflare
      '';

      # Sparky-fitness
      "fit.jervw.dev".extraConfig = ''
        reverse_proxy http://thor:3004
        import cloudflare
      '';
    };
  };
}
