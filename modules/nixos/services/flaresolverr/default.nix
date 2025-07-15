{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.services.flaresolverr;
in {
  options.${namespace}.services.flaresolverr = {
    enable = mkEnableOption "Enable Flaresolverr service";
  };

  # TODO: Add port configuration

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers.flaresolverr = {
      image = "ghcr.io/flaresolverr/flaresolverr";
      ports = [
        "8191:8191"
      ];
      environment = {
        LOG_LEVEL = "info";
        TZ = "Europe/Helsinki";
      };
    };
  };
}
