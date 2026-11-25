{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf optionalAttrs;
  cfg = config.${namespace}.programs.desktop.umbriel;
  monitors = config.${namespace}.monitors;
in
  mkIf cfg.enable {
    programs.umbriel.settings =
      {
        general = {
          autostart = [
            (lib.getExe config.programs.noctalia.package)
          ];
          show_cheatsheet = false;
          # niri focuses windows on xdg-activation; Umbriel defaults to not doing so
          focus_on_activate = true;
        };

        input = {
          keyboard = {
            layout = "us";
            options = "compose:ralt,caps:none";
            repeat_delay = 200;
          };

          touchpad = {
            natural_scroll = true;
            tap = true;
            disable_while_typing = true;
            click_method = "clickfinger";
          };

          focus.follows_mouse = "sloppy";
          cursor.follows_focus = true;
        };

        layout.extent_presets = [0.333 0.5 0.667];
      }
      // optionalAttrs (monitors != {}) {
        output = lib.${namespace}.monitors.toUmbriel monitors;
      };
  }
