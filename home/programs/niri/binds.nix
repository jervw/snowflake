{config, ...}
: {
  programs.niri.settings.binds = with config.lib.niri.actions; {
    "Mod+Return".action = spawn "ghostty";
    "Mod+D".action = spawn "fuzzel";
    "Mod+B".action = spawn "zen";

    "Mod+H".action = focus-column-left;
    "Mod+L".action = focus-column-right;
    "Mod+J".action = focus-window-or-workspace-down;
    "Mod+K".action = focus-window-or-workspace-up;

    "Mod+Shift+H".action = move-column-left;
    "Mod+Shift+L".action = move-column-right;
    "Mod+Shift+K".action = move-column-to-workspace-up;
    "Mod+Shift+J".action = move-column-to-workspace-down;

    "Mod+1".action = focus-workspace 1;
    "Mod+2".action = focus-workspace 2;
    "Mod+3".action = focus-workspace 3;
    "Mod+4".action = focus-workspace 4;
    "Mod+5".action = focus-workspace 5;

    "Mod+Shift+1".action = move-column-to-workspace 1;
    "Mod+Shift+2".action = move-column-to-workspace 2;
    "Mod+Shift+3".action = move-column-to-workspace 3;
    "Mod+Shift+4".action = move-column-to-workspace 4;
    "Mod+Shift+5".action = move-column-to-workspace 5;

    "Mod+Space".action = toggle-window-floating;

    "Mod+Q".action = close-window;
    "Mod+F".action = maximize-column;
    "Mod+P".action = screenshot;
    "Mod+Shift+E".action = quit;
    "Mod+Shift+Slash".action = show-hotkey-overlay;
  };
}
