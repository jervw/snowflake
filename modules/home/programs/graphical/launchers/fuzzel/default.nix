{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.graphical.launchers.fuzzel;
in {
  options.${namespace}.programs.graphical.launchers.fuzzel = {
    enable = lib.mkEnableOption "Enable fuzzel";
  };

  config = mkIf cfg.enable {
    home.packages = [pkgs.bemoji];

    snowflake = {
      programs = {
        graphical = {
          addons = {
            clipman.enable = true;
          };
        };
      };
    };

    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          terminal = "foot -e";
          layer = "overlay";
        };
        border = {
          radius = 15;
          width = 3;
        };
      };
    };
  };
}
