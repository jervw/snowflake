{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.graphical.apps.imv;
in {
  options.${namespace}.programs.graphical.apps.imv = {
    enable = lib.mkEnableOption "Enable imv";
  };

  config = mkIf cfg.enable {
    programs.imv = {
      enable = true;
    };
  };
}
