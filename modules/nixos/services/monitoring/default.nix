{
  config,
  lib,
  namespace,
  ...
}: let
  cfg = config.${namespace}.services.monitoring;
in {
  options.${namespace}.services.monitoring = {
    enable = lib.mkEnableOption "Enable all monitoring exporters";
  };

  config = lib.mkIf cfg.enable {
    services = {
      prometheus.exporters.node.enable = true;
    };
  };
}
