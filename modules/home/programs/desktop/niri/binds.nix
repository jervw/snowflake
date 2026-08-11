{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.desktop.niri;

  workspaceBinds = count:
    builtins.listToAttrs (
      builtins.concatMap (
        x: let
          ws = toString (x + 1);
          num = x + 1;
        in [
          {
            name = "Mod+${ws}";
            value = {focus-workspace = num;};
          }
          {
            name = "Mod+Shift+${ws}";
            value = {move-column-to-workspace = num;};
          }
        ]
      ) (builtins.genList (x: x) count)
    );

  workspaces = workspaceBinds 9;
  noctaliaIpc = args: ["noctalia" "msg"] ++ args;
in
  mkIf cfg.enable {
    wayland.windowManager.niri.settings.binds =
      {
        # Programs
        "Mod+Return" = {spawn = ["ghostty" "+new-window"];};
        "Mod+D" = {spawn = noctaliaIpc ["panel-toggle" "launcher"];};
        "Mod+B" = {spawn = ["uwsm" "app" "--" "brave-origin"];};
        "Mod+N" = {spawn = ["ghostty" "+new-window" "-e" "yazi"];};

        # Essential
        "Mod+Q" = {close-window = {};};
        "Mod+Z" = {screenshot = {};};
        "Mod+Shift+Z" = {screenshot-window = {};};
        "Mod+Ctrl+Z" = {screenshot-screen = {};};
        "Mod+Shift+Slash" = {show-hotkey-overlay = {};};

        # Noctalia binds
        "Mod+Shift+E" = {spawn = noctaliaIpc ["panel-toggle" "session"];};
        "Alt+Tab" = {spawn = noctaliaIpc ["window-switcher"];};
        "Mod+S" = {spawn = noctaliaIpc ["panel-toggle" "control-center"];};
        "Mod+C" = {spawn = noctaliaIpc ["panel-toggle" "clipboard"];};
        "Mod+G" = {spawn = noctaliaIpc ["wallpaper-random"];};
        "Mod+Shift+G" = {spawn = noctaliaIpc ["panel-toggle" "wallpaper"];};

        # Move column focus
        "Mod+H" = {focus-column-or-monitor-left = {};};
        "Mod+L" = {focus-column-or-monitor-right = {};};
        "Mod+J" = {focus-window-or-workspace-down = {};};
        "Mod+K" = {focus-window-or-workspace-up = {};};

        # Resize column and window height
        "Mod+Ctrl+H" = {set-column-width = "-5%";};
        "Mod+Ctrl+L" = {set-column-width = "+5%";};
        "Mod+Ctrl+K" = {set-window-height = "+5%";};
        "Mod+Ctrl+J" = {set-window-height = "-5%";};

        # Move columns
        "Mod+Shift+H" = {move-column-left-or-to-monitor-left = {};};
        "Mod+Shift+L" = {move-column-right-or-to-monitor-right = {};};
        "Mod+Shift+K" = {move-column-to-workspace-up = {};};
        "Mod+Shift+J" = {move-column-to-workspace-down = {};};

        # Move between monitors
        "Mod+comma" = {focus-monitor-next = {};};
        "Mod+period" = {focus-monitor-previous = {};};

        # Toggle overview
        "Mod+Escape" = {toggle-overview = {};};

        # Floating
        "Mod+Space" = {toggle-window-floating = {};};

        # Column manipulation
        "Mod+R" = {switch-preset-column-width = {};};
        "Mod+Shift+R" = {switch-preset-window-height = {};};
        "Mod+Ctrl+R" = {reset-window-height = {};};
        "Mod+F" = {maximize-column = {};};
        "Mod+Shift+F" = {fullscreen-window = {};};
        "Mod+W" = {center-column = {};};
        "Mod+V" = {expand-column-to-available-width = {};};

        # Mouse bindings with cooldown
        "Mod+WheelScrollUp" = {
          _props.cooldown-ms = 150;
          focus-workspace-up = {};
        };
        "Mod+WheelScrollRight" = {
          _props.cooldown-ms = 150;
          focus-column-right = {};
        };
        "Mod+WheelScrollDown" = {
          _props.cooldown-ms = 150;
          focus-workspace-down = {};
        };
        "Mod+WheelScrollLeft" = {
          _props.cooldown-ms = 150;
          focus-column-left = {};
        };

        # Dynamic screencast
        "Mod+Y" = {set-dynamic-cast-window = {};};
        "Mod+Shift+Y" = {set-dynamic-cast-monitor = {};};
        "Mod+U" = {clear-dynamic-cast-target = {};};

        # Window arrangement
        "Mod+Shift+BracketLeft" = {consume-window-into-column = {};};
        "Mod+Shift+BracketRight" = {expel-window-from-column = {};};
        "Mod+BracketLeft" = {consume-or-expel-window-left = {};};
        "Mod+BracketRight" = {consume-or-expel-window-right = {};};

        # Media controls
        "XF86AudioPlay" = {spawn = noctaliaIpc ["media" "toggle"];};
        "XF86AudioPrev" = {spawn = noctaliaIpc ["media" "previous"];};
        "XF86AudioNext" = {spawn = noctaliaIpc ["media" "next"];};
        "XF86AudioRaiseVolume" = {spawn = noctaliaIpc ["volume-up"];};
        "XF86AudioLowerVolume" = {spawn = noctaliaIpc ["volume-down"];};

        # Brightness controls
        "XF86MonBrightnessUp" = {spawn = noctaliaIpc ["brightness" "up"];};
        "XF86MonBrightnessDown" = {spawn = noctaliaIpc ["brightness" "down"];};
      }
      // workspaces;
  }
