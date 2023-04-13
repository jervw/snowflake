{ pkgs, lib, ... }:

let
  modifier = "Mod4";
in
{
  xsession = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      config = {
        inherit modifier;

        defaultWorkspace = "workspace number 1";

        fonts = {
          names = [ "JetBrainsMono Nerd Font" ];
          size = 12.0;
        };
        gaps = {
          inner = 20;
          smartGaps = true;
        };
        keybindings = lib.mkOptionDefault {
          "${modifier}+Return" = "exec alacritty";
          "${modifier}+d" = "exec j4-dmenu-desktop";
          "${modifier}+p" = "exec flameshot gui";
          "${modifier}+z" = "exec alacritty -e joshuto";
          "${modifier}+b" = "exec firefox";

          "${modifier}+q" = "kill";
          "${modifier}+Shift+e" = "exit";
          "${modifier}+Shift+r" = "restart";

          # Focus with vim keys
          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";

          # Move with vim keys
          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+j" = "move down";
          "${modifier}+Shift+k" = "move up";
          "${modifier}+Shift+l" = "move right";

          # Cycle between workspaces
          "${modifier}+Tab" = "workspace next";

          # Toggle tiling / floating
          "${modifier}+Shift+space" = "floating toggle";

        };
        modes.resize = {
          # Resize with vim keys
          "h" = "resize shrink width 10 px or 10 ppt";
          "j" = "resize grow height 10 px or 10 ppt";
          "k" = "resize shrink height 10 px or 10 ppt";
          "l" = "resize grow width 10 px or 10 ppt";

          # More precise resizing
          "Shift+h" = "resize shrink width 1 px or 1 ppt";
          "Shift+j" = "resize grow height 1 px or 1 ppt";
          "Shift+k" = "resize shrink height 1 px or 1 ppt";
          "Shift+l" = "resize grow width 1 px or 1 ppt";

          "Escape" = "mode default";
          "Return" = "mode default";
        };

        bars = [
          {
            position = "bottom";
            trayOutput = "primary";
            statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-bottom.toml";
            fonts = {
              names = [ "JetBrainsMono Nerd Font" ];
              size = 12.0;
            };
            # Colors TODO
          }
        ];
      };
    };
  };

  programs.i3status-rust = {
    enable = true;
    bars = {
      bottom = {
        blocks = [
          {
            block = "music";
            format = " $icon {$combo.str(max_w:20,rot_interval:0.5) $play $next |}";
          }
          {
            block = "sound";
            step_width = 3;
          }
          {
            block = "cpu";
            interval = 1;
            format = " $icon $utilization";
          }
          {
            block = "memory";
            format = " $icon $mem_used_percents.eng(w:1) ";
          }
          {
            block = "battery";
            format = " $icon $percentage ";
            missing_format = "";
          }
          {
            block = "time";
            interval = 60;
            format = " $timestamp.datetime(f:'%a %d/%m %R') ";
          }
        ];
        icons = "awesome4";
        theme = "solarized-dark";
      };
    };
  };
}
