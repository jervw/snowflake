_: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    systemd.target = "graphical-session.target";

    settings = [
      {
        position = "top";
        output = "!HDMI-A-1";
        layer = "top";
        modules-left = ["custom/launcher" "hyprland/workspaces"];
        modules-center = ["custom/playerctl"];
        modules-right = ["tray" "network" "pulseaudio" "clock" "custom/notification"];

        clock = {
          interval = 1;
          format = "󱑀 {:%H:%M}";
          tooltip = "true";
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
          format-alt = " {:%d/%m}";
        };

        "hyprland/workspaces" = {
          active-only = false;
          all-outputs = true;
          disable-scroll = false;
          on-scroll-up = "hyprctl dispatch workspace e-1";
          on-scroll-down = "hyprctl dispatch workspace e+1";
          format = "{icon}";
          on-click = "activate";
          format-icons = {
            urgent = "";
            active = "";
            default = "";
            sort-by-number = true;
          };
        };

        "custom/playerctl" = {
          format = "{icon} {}";
          return-type = "json";
          max-length = 64;
          exec = ''
            playerctl -a metadata --format '{"text": "{{artist}} - {{markup_escape(title)}}", "tooltip": "{{playerName}} : {{markup_escape(title)}}", "alt": "{{status}}", "class": "{{status}}"}' -F'';
          on-click = "playerctl play-pause";
          on-click-right = "playerctl next";
          format-icons = {
            Playing = " ";
            Paused = " ";
          };
        };

        tray = {
          icon-size = 18;
          spacing = 5;
        };

        network = {
          format-wifi = "{icon}  {essid}";
          format-ethernet = " {ifname}";
          format-linked = " {ifname} (No IP)";
          format-disconnected = "󰤭";
          on-click = "nm-connection-editor";
          format-cions = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰝟";
          format-icons = {default = ["󰕿" "󰖀" "󱄠"];};
          on-click = "pavucontrol";
        };

        "custom/launcher" = {
          format = "";
          on-click = "fuzzel";
          tooltip = "false";
        };

        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };
      }
    ];
    style = ''
      * {
        all: unset;
        font-family: Inter, FontAwesome, Noto Sans CJK;
        font-size: 15px;
        font-weight: bold;
      }

      window#waybar {
        background: transparent;
      }

      window#waybar > box {
        margin: 5px 10px 0 5px;
        border-radius: 8px;
        color: #242424;
      }

      tooltip {
        border-radius: 4px;
        background-color: rgba(40, 40, 40, 0.7);
        font-size: 0.8em;
        color: #fff;
      }

      #workspaces {
        border-radius: 4px;
        margin: 5px 3px;
        padding: 8px 5px;
        border-radius: 16px;
        border: solid 0px #cdd6f4;
      }

      #workspaces button {
        padding: 0px 5px;
        margin: 0px 3px;
        border-radius: 16px;
        background-color: #242424;
        min-width: 15px;
        min-height: 12px;
        transition: all 200ms ease-in-out;
        opacity: 0.5;
      }

      #workspaces button.active {
        min-width: 35px;
        opacity: 1;
      }

      #workspaces button.urgent {
        background-color: #f25e37;
        opacity: 1;
      }

      #tray {
        padding: 0px 5px;
        margin: 0px 6px;
        border-radius: 16px;
      }

      #clock {
        margin-left: 5px;
        margin-right: 3px;
        padding-right: 3px;
        padding-top: 1px;
        padding-bottom: 1px;
        border-radius: 4px;
      }

      #pulseaudio {
        margin: 0 10px 0;
        padding: 1px 3px;
        border-radius: 4px;
      }

      #custom-launcher {
        margin: 0;
        padding: 0 13px 0;
        font-size: 24px;
      }

      #custom-playerctl {
        padding: 0px 5px 0px 10px;
        margin: 5px 7px;
      }
      #custom-notification {
        font-family: "Ubuntu Nerd Font";
      }
    '';
  };
}
