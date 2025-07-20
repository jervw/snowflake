{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;
  cfg = config.${namespace}.services.adguard;
in {
  options.${namespace}.services.adguard = {
    enable = mkEnableOption "Enable AdGuard Home service";
    host = mkOption {
      type = lib.types.str;
      default = "dns.jervw.dev";
      description = "Reverse proxy host name for the AdGuard Home service";
    };
    port = mkOption {
      type = lib.types.number;
      default = 3000;
    };
  };

  config = mkIf cfg.enable {
    services = {
      adguardhome = {
        enable = true;
        openFirewall = true;
        port = cfg.port;
      };

      caddy.virtualHosts."${cfg.host}".extraConfig = ''
        reverse_proxy http://thor:${toString cfg.port}
        import cloudflare
      '';
    };

    networking.firewall = {
      allowedUDPPorts = [53]; # DNS resolver.
    };
  };
}
