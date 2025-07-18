{
  config,
  lib,
  namespace,
  ...
}: let
  cfg = config.${namespace}.programs.graphical.addons.gamescope;
in {
  options.${namespace}.programs.graphical.addons.gamescope = {
    enable = lib.mkEnableOption "Enable Gamescope";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      gamescope = {
        enable = true;

        capSysNice = true;
        args = [
          "--rt"
          "--expose-wayland"
        ];
      };
      steam.gamescopeSession.enable = true;
    };
  };
}
