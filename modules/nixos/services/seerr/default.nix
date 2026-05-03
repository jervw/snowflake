{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;
  cfg = config.${namespace}.services.seerr;
in {
  options.${namespace}.services.seerr = {
    enable = mkEnableOption "Enable Seerr service";
    host = mkOption {
      type = lib.types.str;
      default = "seerr.jervw.dev";
      description = "Reverse proxy host name for the Seerr service";
    };
    port = mkOption {
      type = lib.types.number;
      default = 5055;
    };
  };

  config = mkIf cfg.enable {
    services = {
      seerr = {
        enable = true;
        openFirewall = true;
        inherit (cfg) port;
      };
      caddy.virtualHosts."${cfg.host}".extraConfig = ''
        reverse_proxy http://thor:${toString cfg.port}
        import cloudflare
      '';
    };
  };
}
