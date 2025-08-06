{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.${namespace}.services.monitoring.cadvisor;
in {
  options.${namespace}.services.monitoring.cadvisor = {
    enable = lib.mkEnableOption "Enable cAdvisor exporter";
  };

  config = mkIf cfg.enable {
    services.cadvisor = {
      enable = true;
    };
  };
}
