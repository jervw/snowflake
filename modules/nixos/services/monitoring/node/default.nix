{
  config,
  lib,
  namespace,
  ...
}: let
  cfg = config.${namespace}.services.monitoring.node;
in {
  options.${namespace}.services.monitoring.node = {
    enable = lib.mkEnableOption "Enable node-exporter";
  };

  config = lib.mkIf cfg.enable {
    services.prometheus.exporters = {
      node.enable = true;
    };
  };
}
