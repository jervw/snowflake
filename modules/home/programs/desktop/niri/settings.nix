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
        prefer-no-csd = {};
        hotkey-overlay.skip-at-startup = {};

        # TODO Maybe use full paths in the future.
        spawn-at-startup = [
          "noctalia"
        ];

        screenshot-path = "~/pics/Screenshots/Screenshot-%Y%m%d-%H%M%S.png";

        input = {
          keyboard = {
            xkb = {
              layout = "us";
              options = "caps:none";
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
