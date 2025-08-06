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
        reverse_proxy http://thor:8089
      '';

      # YamTrack
      "track.jervw.dev".extraConfig = ''
        reverse_proxy http://thor:8001
      '';

      # Sparky-fitness
      "fit.jervw.dev".extraConfig = ''
        reverse_proxy http://thor:3004
      '';
    };
  };
}
