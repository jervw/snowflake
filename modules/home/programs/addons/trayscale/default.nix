{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.addons.trayscale;
in {
  options.${namespace}.programs.addons.trayscale = {
    enable = lib.mkEnableOption "Enable Trayscale";
  };

  config = mkIf cfg.enable {
    services.trayscale = {
      enable = true;
      hideWindow = true;
    };
  };
}
