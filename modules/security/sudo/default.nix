{
  config,
  lib,
  namespace,
  ...
}: let
  cfg = config.${namespace}.security.sudo;
in {
  options.${namespace}.security.sudo = {
    enable = lib.mkEnableOption "replacing sudo with sudo-rs";
  };

  config = lib.mkIf cfg.enable {
    security.sudo.enable = false;
    security.sudo-rs = {
      enable = true;
      wheelNeedsPassword = false;
      execWheelOnly = true;
    };
  };
}
