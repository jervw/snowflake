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
        import cloudflare
      '';
      # Booklore
      "books.jervw.dev".extraConfig = ''
        reverse_proxy http://thor:6060
        import cloudflare
      '';

      # YamTrack
      "track.jervw.dev".extraConfig = ''
        reverse_proxy http://thor:8001
        import cloudflare
      '';
      # Tasks-md
      "todo.jervw.dev".extraConfig = ''
        reverse_proxy http://thor:8075
        import cloudflare
      '';

      # Tubearchivist
      "tube.jervw.dev".extraConfig = ''
        reverse_proxy http://thor:8933
        import cloudflare
      '';
    };
  };
}
