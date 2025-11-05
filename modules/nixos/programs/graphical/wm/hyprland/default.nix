{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.${namespace}.programs.graphical.wm.hyprland;
in {
  options.${namespace}.programs.graphical.wm.hyprland = {
    enable = lib.mkEnableOption "Enable Hyprland";
  };

  config = mkIf cfg.enable {
    programs = {
      hyprland = {
        enable = true;
        withUWSM = true;
      };
    };

    snowflake = {
      programs = {
        graphical = {
          display-managers = {
            greetd = {
              enable = true;
              command = "${lib.getExe config.programs.hyprland.package} &> /dev/null";
            };
          };
        };
      };
    };
  };
}
