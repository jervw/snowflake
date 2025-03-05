_: {
  programs.niri.settings.binds = {
    # Programs
    "Mod+Return".action.spawn = "ghostty";
    "Mod+D".action.spawn = "fuzzel";
    "Mod+B".action.spawn = "zen";

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
    "Mod+Minus".action.set-column-width = "-5%";
    "Mod+Equal".action.set-column-width = "+5%";
    "Mod+Shift+Minus".action.set-window-height = "-5%";
    "Mod+Shift+Equal".action.set-window-height = "+5%";

    # Move columns
    "Mod+Shift+H".action.move-column-left-or-to-monitor-left = {};
    "Mod+Shift+L".action.move-column-right-or-to-monitor-right = {};
    "Mod+Shift+K".action.move-column-to-workspace-up = {};
    "Mod+Shift+J".action.move-column-to-workspace-down = {};

    # Go to workspace
    "Mod+1".action.focus-workspace = 1;
    "Mod+2".action.focus-workspace = 2;
    "Mod+3".action.focus-workspace = 3;
    "Mod+4".action.focus-workspace = 4;
    "Mod+5".action.focus-workspace = 5;

    # Move column to specific workspace
    "Mod+Shift+1".action.move-column-to-workspace = 1;
    "Mod+Shift+2".action.move-column-to-workspace = 2;
    "Mod+Shift+3".action.move-column-to-workspace = 3;
    "Mod+Shift+4".action.move-column-to-workspace = 4;
    "Mod+Shift+5".action.move-column-to-workspace = 5;

    # Floating
    "Mod+Tab".action.switch-focus-between-floating-and-tiling = {};
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

    # Misc
    "Mod+Shift+BracketLeft".action.consume-window-into-column = {};
    "Mod+Shift+BracketRight".action.expel-window-from-column = {};
    "Mod+BracketLeft".action.consume-or-expel-window-left = {};
    "Mod+BracketRight".action.consume-or-expel-window-right = {};
  };
}
