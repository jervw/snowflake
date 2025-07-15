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
  };

  # TODO: Add port configuration

  config = mkIf cfg.enable {
    services = {
      adguardhome.enable = true;
      caddy.virtualHosts."${cfg.host}".extraConfig = ''
        reverse_proxy http://thor:3000
        import cloudflare
      '';
    };

    networking.firewall = {
      allowedUDPPorts = [53]; # DNS resolver.
    };
  };
}
