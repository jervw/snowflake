{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.${namespace}.programs.wm.niri;
  # mkCommand = command: {
  #   command = [command];
  # };
in
  mkIf cfg.enable {
    programs.niri = {
      settings = {
        debug = {
          honor-xdg-activation-with-invalid-serial = [];
        };

        spawn-at-startup = [];

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

        xwayland-satellite = {
          enable = true;
          path = lib.getExe pkgs.xwayland-satellite;
        };

        prefer-no-csd = true;
        hotkey-overlay.skip-at-startup = true;
      };
    };
  }
