{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.graphical.addons.wlsunset;
in {
  options.${namespace}.programs.graphical.addons.wlsunset = {
    enable = lib.mkEnableOption "Enable wlsunset service";
  };

  config = mkIf cfg.enable {
    services.wlsunset = {
      enable = true;
      latitude = "60.1699";
      longitude = "24.9384";
    };
  };
}
