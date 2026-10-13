{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.${namespace}.programs.desktop.niri;
in
  mkIf cfg.enable {
    wayland.windowManager.niri = {
      settings = {
        _children = lib.${namespace}.monitors.toNiri config.${namespace}.monitors;

        prefer-no-csd = {};
        hotkey-overlay.skip-at-startup = {};

        spawn-at-startup = [
          (lib.getExe config.programs.noctalia.package)
        ];

        screenshot-path = "~/pics/Screenshots/Screenshot-%Y%m%d-%H%M%S.png";

        input = {
          keyboard = {
            xkb = {
              layout = "us";
              options = "compose:ralt,caps:none";
            };
            repeat-delay = 200;
          };

          focus-follows-mouse = {};
          warp-mouse-to-focus = {};
        };

        debug = {
          honor-xdg-activation-with-invalid-serial = {};
        };
      };
    };
  }
