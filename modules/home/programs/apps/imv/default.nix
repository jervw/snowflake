{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.apps.imv;
in {
  options.${namespace}.programs.apps.imv = {
    enable = lib.mkEnableOption "Enable imv";
  };

  config = mkIf cfg.enable {
    programs.imv = {
      enable = true;
    };
  };
}
