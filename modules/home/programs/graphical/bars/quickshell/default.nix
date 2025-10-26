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
    home.packages = with pkgs; [inputs.noctalia.packages.${system}.default];

    programs.noctalia-shell = {
      enable = true;
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
