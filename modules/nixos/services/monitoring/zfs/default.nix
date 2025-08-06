{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.${namespace}.services.monitoring.zfs;
in {
  options.${namespace}.services.monitoring.zfs = {
    enable = lib.mkEnableOption "Enable zfs exporter";
  };

  config = mkIf cfg.enable {
    services.prometheus.exporters = {
      zfs.enable = true;
    };
  };
}
