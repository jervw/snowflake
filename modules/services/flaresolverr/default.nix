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
    virtualisation.oci-containers.containers.flaresolverr = {
      image = "ghcr.io/flaresolverr/flaresolverr";
      ports = ["${toString cfg.port}:8191"];
      environment = {
        LOG_LEVEL = "info";
        TZ = "Europe/Helsinki";
      };
    };
  };
}
