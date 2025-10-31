{
  config,
  lib,
  pkgs,
  inputs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) disabled;

  cfg = config.${namespace}.programs.graphical.bars.quickshell;
in {
  options.${namespace}.programs.graphical.bars.quickshell = {
    enable = lib.mkEnableOption "Enable quickshell";
  };

  config = mkIf cfg.enable {
    programs.noctalia-shell = {
      enable = true;
      package = inputs.noctalia.packages.${pkgs.system}.default;
      settings = {};
    };

    services.hyprpaper.enable = lib.mkForce false;

    snowflake = {
      programs = {
        defaults = {
          launcher = "noctalia-shell ipc call launcher toggle";
          lock = "noctalia-shell ipc call lockScreen lock";
        };
        graphical = {
          addons = {
            hyprlock = disabled;
            swaync = disabled;
          };
          bars = {
            waybar = disabled;
          };
          launchers = {
            # Dont disable even when using quickshell as launcher, as some other software still depend on fuzzel like bemoji and clipman
            # fuzzel = disabled;
          };
        };
      };
    };
  };
}
