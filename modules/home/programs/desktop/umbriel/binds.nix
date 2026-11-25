{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.desktop.umbriel;

  workspaceBinds = count:
    builtins.listToAttrs (
      builtins.concatMap (
        x: let
          ws = toString (x + 1);
        in [
          {
            name = "Mod+${ws}";
            value = "workspace-switch ${ws}";
          }
          {
            name = "Mod+Shift+${ws}";
            value = "column-move-to-workspace ${ws}";
          }
        ]
      ) (builtins.genList (x: x) count)
    );

  workspaces = workspaceBinds 9;
  noctaliaIpc = args: "spawn ${lib.getExe config.programs.noctalia.package} msg ${args}";
in
  mkIf cfg.enable {
    # Defining [keybinds] replaces Umbriel's built-in bind set entirely.
    programs.umbriel.settings.keybinds =
      {
        # Programs
        "Mod+Return" = "spawn foot";
        "Mod+D" = noctaliaIpc "panel-toggle launcher";
        "Mod+B" = "spawn uwsm app -- librewolf";
        "Mod+N" = "spawn foot yazi";
        "Mod+O" = "spawn ${lib.getExe pkgs.${namespace}.wl-ocr}";
        "Mod+T" = "spawn voxtype record toggle";
        "Mod+Shift+T" = "spawn voxtype-language";

        # Essential
        "Mod+Q" = "window-close";
        # Umbriel has no built-in screenshot UI, so use Noctalia's
        "Mod+Z" = noctaliaIpc "screenshot-region";
        "Mod+Shift+Z" = noctaliaIpc "screenshot-window";
        "Mod+Ctrl+Z" = noctaliaIpc "screenshot-fullscreen";
        "Mod+Shift+Slash" = "cheatsheet-toggle";

        # Noctalia binds
        "Mod+Shift+E" = noctaliaIpc "panel-toggle session";
        "Alt+Tab" = noctaliaIpc "window-switcher";
        "Mod+S" = noctaliaIpc "panel-toggle control-center";
        "Mod+C" = noctaliaIpc "panel-toggle clipboard";
        "Mod+G" = noctaliaIpc "wallpaper-random";
        "Mod+Shift+G" = noctaliaIpc "panel-toggle wallpaper";

        # Move focus
        "Mod+H" = "window-focus-or-output-left";
        "Mod+L" = "window-focus-or-output-right";
        "Mod+J" = "window-focus-or-workspace-down";
        "Mod+K" = "window-focus-or-workspace-up";

        # Resize: primary extent is column width in scrolling, the split or master
        # fraction in dwindle/master; secondary extent is the row height
        "Mod+Ctrl+H" = "window-modify-primary-extent -0.05";
        "Mod+Ctrl+L" = "window-modify-primary-extent +0.05";
        "Mod+Ctrl+K" = "window-modify-secondary-extent +0.05";
        "Mod+Ctrl+J" = "window-modify-secondary-extent -0.05";

        # Move columns
        "Mod+Shift+H" = "window-move-or-output-left";
        "Mod+Shift+L" = "window-move-or-output-right";
        "Mod+Shift+K" = "column-move-to-workspace-previous";
        "Mod+Shift+J" = "column-move-to-workspace-next";

        # Focus between monitors
        "Mod+Comma" = "output-focus-left";
        "Mod+Period" = "output-focus-right";

        # Toggle overview
        "Mod+Escape" = {
          action = "overview-toggle";
          repeat = false;
        };

        # Floating
        "Mod+Space" = {
          action = "window-toggle-floating";
          repeat = false;
        };

        # Column manipulation
        "Mod+R" = "window-cycle-primary-extent";
        "Mod+Shift+R" = "window-cycle-secondary-extent";
        "Mod+F" = {
          action = "window-toggle-maximize";
          repeat = false;
        };
        "Mod+Shift+F" = {
          action = "window-toggle-fullscreen";
          repeat = false;
        };
        "Mod+W" = "column-center";

        # Mouse bindings
        "Mod+WheelUp" = "workspace-previous";
        "Mod+WheelRight" = "window-focus-right";
        "Mod+WheelDown" = "workspace-next";
        "Mod+WheelLeft" = "window-focus-left";

        # Dynamic screencast
        "Mod+Y" = "screencast-set-window";
        "Mod+Shift+Y" = "screencast-set-output";
        "Mod+U" = "screencast-clear";

        # Window arrangement
        "Mod+Shift+BracketLeft" = "window-consume-from-right";
        # No direct expel action; expels when the column has other windows
        "Mod+Shift+BracketRight" = "window-consume-or-expel-right";
        "Mod+BracketLeft" = "window-consume-or-expel-left";
        "Mod+BracketRight" = "window-consume-or-expel-right";

        # Media controls
        "XF86AudioPlay" = noctaliaIpc "media toggle";
        "XF86AudioPrev" = noctaliaIpc "media previous";
        "XF86AudioNext" = noctaliaIpc "media next";
        "XF86AudioRaiseVolume" = noctaliaIpc "volume-up";
        "XF86AudioLowerVolume" = noctaliaIpc "volume-down";

        # Brightness controls
        "XF86MonBrightnessUp" = noctaliaIpc "brightness-up";
        "XF86MonBrightnessDown" = noctaliaIpc "brightness-down";

        # Keyboard backlight controls
        "XF86KbdBrightnessUp" = noctaliaIpc "keyboard-backlight-up";
        "XF86KbdBrightnessDown" = noctaliaIpc "keyboard-backlight-down";
        "XF86KbdLightOnOff" = noctaliaIpc "keyboard-backlight-toggle";
      }
      // workspaces;
  }
