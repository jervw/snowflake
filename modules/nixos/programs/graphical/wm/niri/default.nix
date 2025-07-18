{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.${namespace}.programs.graphical.wm.niri;
in {
  options.${namespace}.programs.graphical.wm.niri = {
    enable = lib.mkEnableOption "Enable Niri";
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
              command = "${config.programs.niri.package}/bin/niri-session &> /dev/null";
            };
          };
        };
      };
    };
  };
}
