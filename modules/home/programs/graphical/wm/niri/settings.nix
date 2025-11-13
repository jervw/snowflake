{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.catppuccin) cursors;
  cfg = config.${namespace}.programs.graphical.wm.niri;

  mkCommand = command: {
    command = [command];
  };
in
  mkIf cfg.enable {
    programs.niri = {
      settings = {
        environment = {
          NIXOS_OZONE_WL = "1";
        };

        debug = {
          honor-xdg-activation-with-invalid-serial = [];
        };

        spawn-at-startup = [];

        cursor = {
          theme = "catppuccin-${cursors.flavor}-${cursors.accent}-cursors";
          size = config.home.pointerCursor.size;
        };

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
