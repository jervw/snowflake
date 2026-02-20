{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.wm.niri;
  inherit (config.${namespace}.programs) defaults;

  workspaceBinds = count:
    builtins.listToAttrs (
      builtins.concatMap (
        x: let
          ws = toString (x + 1);
          num = x + 1;
        in [
          {
            name = "Mod+${ws}";
            value = {action.focus-workspace = num;};
          }
          {
            name = "Mod+Shift+${ws}";
            value = {action.move-column-to-workspace = num;};
          }
        ]
      ) (builtins.genList (x: x) count)
    );

  workspaces = workspaceBinds 9;

  cmdToArgv = cmd: lib.splitString " " cmd;
  noctaliaIpc = args: ["noctalia-shell" "ipc" "call"] ++ args;
in
  mkIf cfg.enable {
    programs.niri.settings.binds =
      {
        # Programs
        "Mod+Return".action.spawn = cmdToArgv defaults.terminal;
        "Mod+D".action.spawn = cmdToArgv defaults.launcher;
        "Mod+B".action.spawn = cmdToArgv defaults.browser;
        "Mod+N".action.spawn = (cmdToArgv defaults.terminal) ++ ["-e" "yazi"];

        # Essential
        "Mod+Q".action.close-window = {};
        "Mod+Z".action.screenshot = {};
        "Mod+Shift+Z".action.screenshot-window = {};
        "Mod+Ctrl+Z".action.screenshot-screen = {};
        "Mod+Shift+Slash".action.show-hotkey-overlay = {};

        # Move column focus
        "Mod+H".action.focus-column-or-monitor-left = {};
        "Mod+L".action.focus-column-or-monitor-right = {};
        "Mod+J".action.focus-window-or-workspace-down = {};
        "Mod+K".action.focus-window-or-workspace-up = {};

        # Resize column and window height
        "Mod+Ctrl+H".action.set-column-width = "-5%";
        "Mod+Ctrl+L".action.set-column-width = "+5%";
        "Mod+Ctrl+K".action.set-window-height = "+5%";
        "Mod+Ctrl+J".action.set-window-height = "-5%";

        # Move columns
        "Mod+Shift+H".action.move-column-left-or-to-monitor-left = {};
        "Mod+Shift+L".action.move-column-right-or-to-monitor-right = {};
        "Mod+Shift+K".action.move-column-to-workspace-up = {};
        "Mod+Shift+J".action.move-column-to-workspace-down = {};

        # Move between monitors
        "Mod+Tab".action.focus-monitor-next = {};
        "Mod+Shift+Tab".action.focus-monitor-previous = {};

        # Toggle overview
        "Mod+Escape".action.toggle-overview = {};

        # Floating
        "Mod+Space".action.toggle-window-floating = {};

        # Column manipulation
        "Mod+R".action.switch-preset-column-width = {};
        "Mod+Shift+R".action.switch-preset-window-height = {};
        "Mod+Ctrl+R".action.reset-window-height = {};
        "Mod+F".action.maximize-column = {};
        "Mod+Shift+F".action.fullscreen-window = {};
        "Mod+C".action.center-column = {};
        "Mod+V".action.expand-column-to-available-width = {};

        # Mouse bindings
        "Mod+WheelScrollUp" = {
          action.focus-workspace-up = {};
          cooldown-ms = 150;
        };
        "Mod+WheelScrollRight" = {
          action.focus-column-right = {};
          cooldown-ms = 150;
        };
        "Mod+WheelScrollDown" = {
          action.focus-workspace-down = {};
          cooldown-ms = 150;
        };
        "Mod+WheelScrollLeft" = {
          action.focus-column-left = {};
          cooldown-ms = 150;
        };

        # Dynamic screencast
        "Mod+Y".action.set-dynamic-cast-window = {};
        "Mod+Shift+Y".action.set-dynamic-cast-monitor = {};
        "Mod+U".action.clear-dynamic-cast-target = {};

        # Media controls
        "XF86AudioPlay".action.spawn = noctaliaIpc ["media" "playPause"];
        "XF86AudioPrev".action.spawn = noctaliaIpc ["media" "previous"];
        "XF86AudioNext".action.spawn = noctaliaIpc ["media" "next"];
        "XF86AudioRaiseVolume".action.spawn = noctaliaIpc ["volume" "increase"];
        "XF86AudioLowerVolume".action.spawn = noctaliaIpc ["volume" "decrease"];

        # Brightness controls
        "XF86MonBrightnessUp".action.spawn = noctaliaIpc ["brightness" "increase"];
        "XF86MonBrightnessDown".action.spawn = noctaliaIpc ["brightness" "decrease"];
        # "XF86KbdBrightnessUp".action.spawn = ["swayosd-client" "--device=apple::kbd_backlight" "--brightness" "raise"];
        # "XF86KbdBrightnessDown".action.spawn = ["swayosd-client" "--device=apple::kbd_backlight" "--brightness" "lower"];

        "Mod+Shift+E".action.spawn = noctaliaIpc ["sessionMenu" "toggle"];
        "Mod+G".action.spawn = noctaliaIpc ["wallpaper" "random"];

        # Misc
        "Mod+Shift+BracketLeft".action.consume-window-into-column = {};
        "Mod+Shift+BracketRight".action.expel-window-from-column = {};
        "Mod+BracketLeft".action.consume-or-expel-window-left = {};
        "Mod+BracketRight".action.consume-or-expel-window-right = {};
      }
      // workspaces;
  }
