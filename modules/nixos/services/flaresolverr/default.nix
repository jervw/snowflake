{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;
  cfg = config.${namespace}.services.flaresolverr;
in {
  options.${namespace}.services.flaresolverr = {
    enable = mkEnableOption "Enable Flaresolverr service";
    port = mkOption {
      type = lib.types.number;
      default = 8191;
    };
  };

  config = mkIf cfg.enable {
    services.flaresolverr = {
      enable = true;
      inherit (cfg) port;
    };

    systemd.services.flaresolverr.environment.HOST = "127.0.0.1";
  };
}
