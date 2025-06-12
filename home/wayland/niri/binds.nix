_: let
  term = "foot";
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
in {
  programs.niri.settings.binds =
    {
      # Programs
      "Mod+Return".action.spawn = [term];
      "Mod+Escape".action.spawn = ["missioncenter"];
      "Mod+D".action.spawn = ["fuzzel"];
      "Mod+B".action.spawn = ["zen"];
      "Mod+Y".action.spawn = ["uuctl"];
      "Mod+M".action.spawn = ["bemoji" "-t"];
      "Mod+N".action.spawn = [term "-e" "yazi"];
      "Mod+I".action.spawn = ["clipman" "pick" "--tool=CUSTOM" "--tool-args=fuzzel -d"];

      # Essential
      "Mod+Q".action.close-window = {};
      "Mod+Z".action.screenshot = {};
      "Mod+Shift+Z".action.screenshot-window = {};
      "Mod+Ctrl+Z".action.screenshot-screen = {};
      "Mod+Shift+E".action.quit = {};
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
      "Mod+Backspace".action.toggle-overview = {};

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
      "Mod+WheelScrollDown" = {
        action.focus-workspace-down = {};
        cooldown-ms = 150;
      };
      "Mod+WheelScrollUp" = {
        action.focus-workspace-up = {};
        cooldown-ms = 150;
      };
      "Mod+WheelScrollRight".action.focus-column-right = {};
      "Mod+WheelScrollLeft".action.focus-column-left = {};

      # Media controls
      "XF86AudioRaiseVolume".action.spawn = ["swayosd-client" "--output-volume" "raise"];
      "XF86AudioLowerVolume".action.spawn = ["swayosd-client" "--output-volume" "lower"];
      "XF86AudioMute".action.spawn = ["swayosd-client" "--output-volume" "mute-toggle"];

      # Misc
      "Mod+Shift+BracketLeft".action.consume-window-into-column = {};
      "Mod+Shift+BracketRight".action.expel-window-from-column = {};
      "Mod+BracketLeft".action.consume-or-expel-window-left = {};
      "Mod+BracketRight".action.consume-or-expel-window-right = {};
    }
    // workspaces;
}
