{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;
  cfg = config.${namespace}.services.tautulli;
in {
  options.${namespace}.services.tautulli = {
    enable = mkEnableOption "Enable Tautulli service";
    host = mkOption {
      type = lib.types.str;
      default = "tautulli.jervw.dev";
      description = "Reverse proxy host name for the Tautulli service";
    };
  };

  # TODO: Add port configuration

  config = mkIf cfg.enable {
    services = {
      tautulli.enable = true;
      caddy.virtualHosts."${cfg.host}".extraConfig = ''
        reverse_proxy http://thor:8181
        import cloudflare
      '';
    };
  };
}
