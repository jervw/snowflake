{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.graphical.addons.trayscale;
in {
  options.${namespace}.programs.graphical.addons.trayscale = {
    enable = lib.mkEnableOption "Enable Trayscale";
  };

  config = mkIf cfg.enable {
    services.trayscale = {
      enable = true;
      hideWindow = true;
    };
  };
}
