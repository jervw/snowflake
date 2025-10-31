{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.${namespace}.programs.graphical.wm.niri;

  mkCommand = command: {
    command = [command];
  };
in
  mkIf cfg.enable {
    programs.niri = {
      settings = {
        environment = {
          DISPLAY = ":0";
          NIXOS_OZONE_WL = "1";
        };

        spawn-at-startup = [
          (mkCommand config.${namespace}.programs.defaults.lock)
          (mkCommand "xwayland-satellite")
        ];

        input = {
          keyboard = {
            xkb = {
              layout = "us";
              options = "caps:none";
            };
            repeat-delay = 200;
          };

          focus-follows-mouse.enable = true;
          warp-mouse-to-focus.enable = true;
        };

        prefer-no-csd = true;
        hotkey-overlay.skip-at-startup = true;
      };
    };
  }
