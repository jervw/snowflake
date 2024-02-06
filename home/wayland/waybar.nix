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
        height = 16;
        margin-top = 0;
        margin-bottom = 0;
        margin-left = 0;
        margin-right = 0;
        modules-left = ["custom/launcher" "custom/playerctl" "custom/playerlabel"];
        modules-center = ["hyprland/workspaces"];
        modules-right = ["tray" "pulseaudio" "cpu" "clock"];
        clock = {
          format = "󱑍 {:%H:%M}";
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
          format = "{icon}";
          return-type = "json";
          max-length = 64;
          exec = ''
            playerctl -a metadata --format '{"text": "{{artist}} - {{markup_escape(title)}}", "tooltip": "{{playerName}} : {{markup_escape(title)}}", "alt": "{{status}}", "class": "{{status}}"}' -F'';
          on-click = "playerctl play-pause";
          on-click-right = "playerctl next";
          format-icons = {
            Playing = "<span foreground='#6791eb'> </span>";
            Paused = "<span foreground='#cdd6f4'> </span>";
          };
        };

        "custom/playerlabel" = {
          format = "<span>{}</span>";
          return-type = "json";
          max-length = 48;
          exec = ''
            playerctl -a metadata --format '{"text": "{{artist}} - {{markup_escape(title)}}", "tooltip": "{{playerName}} : {{markup_escape(title)}}", "alt": "{{status}}", "class": "{{status}}"}' -F'';
          on-click = "playerctl play-pause";
          on-click-right = "playerctl next";
          format-icons = {
            Playing = "<span foreground='#6791eb'> </span>";
            Paused = "<span foreground='#cdd6f4'> </span>";
          };
        };

        memory = {
          format = "󰍛 {}%";
          format-alt = "󰍛 {used}/{total} GiB";
          interval = 5;
        };

        cpu = {
          format = "󰻠 {usage}%";
          format-alt = "󰻠 {avg_frequency} GHz";
          interval = 5;
        };

        disk = {
          format = "󰋊 {}%";
          format-alt = "󰋊 {used}/{total} GiB";
          interval = 5;
          path = "/";
        };
        tray = {
          icon-size = 18;
          spacing = 5;
        };
        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰝟";
          format-icons = {default = ["󰕿" "󰖀" "󱄠"];};
          on-click = "pavucontrol";
        };
        "custom/launcher" = {
          format = "";
          on-click = "waypaper";
          tooltip = "false";
        };
      }
    ];
    style = ''
      * {
          font-family: JetBrainsMono Nerd Font, FontAwesome, Noto Sans CJK;
          font-size: 15px;
          font-style: normal;
          font-weight: bold;
          min-height: 0;
      	}

      window#waybar {
        background: rgba(25, 35, 48, 0.8);
        color: #cdcecf;
      }

      #workspaces {
      	background: #12162E;
      	margin: 5px 5px;
        padding: 8px 5px;
      	border-radius: 16px;
        border: solid 0px #cdd6f4;
        font-weight: normal;
        font-style: normal;
      }
      #workspaces button {
          padding: 0px 5px;
          margin: 0px 3px;
          border-radius: 16px;
          color: #2f354a;
          background-color: #2f354a;
          transition: all 0.3s ease-in-out;
      }

      #workspaces button.active {
          color: #cdd6f4;
          background-color: #cdd6f4;
          border-radius: 16px;
          min-width: 50px;
          background-size: 400% 400%;
          transition: all 0.3s ease-in-out;
      }

      #workspaces button:hover {
      	background-color: #cdd6f4;
      	color: #cdd6f4;
      	border-radius: 16px;
        min-width: 50px;
        background-size: 400% 400%;
      }

      #custom-date, #clock, #battery, #pulseaudio, #network, #custom-launcher {
        background: transparent;
      	padding: 5px;
      	margin: 5px;
        border-radius: 8px;
        border: solid 0px #f4d9e1;
      }

      #custom-date {
      	color: #192330;
      }

      #tray {
          background: #12162E;
          margin: 5px;
          border-radius: 16px;
          padding: 0px 10px;
      }

      #clock {
          background-color: #12162E;
          border-radius: 0px 0px 0px 24px;
          padding-left: 13px;
          padding-right: 15px;
          margin-right: 0px;
          margin-left: 10px;
          margin-top: 0px;
          margin-bottom: 0px;
          font-weight: bold;
      }

      #battery {
          color: #9ece6a;
      }

      #battery.charging {
          color: #9ece6a;
      }

      #battery.warning:not(.charging) {
          background-color: #f7768e;
          color: #24283b;
          border-radius: 5px;
      }

      #network {
          border-radius: 8px;
          margin-right: 5px;
      }

      #pulseaudio {
          border-radius: 8px;
          margin-left: 0px;
          font-weight: bold;
      }

      #pulseaudio.muted {
          color: #242f33;
          border-radius: 8px;
          margin-left: 0px;
          font-weight: bold;
      }

      #custom-launcher {
          color: #cdd6f4;
          background-color: #12162E;
          border-radius: 0px 24px 0px 0px;
          margin: 0;
          padding: 0 20px 0 13px;
          font-size: 20px;
      }

      #custom-launcher button:hover {
          background-color: #393b44;
          color: transparent;
          border-radius: 8px;
          margin-right: -5px;
          margin-left: 10px;
      }

      #custom-playerctl {
        background: #12162E;
        padding: 0px 5px 0px 10px;
        border-radius: 16px;
        margin: 5px 7px;
        font-size: 16px;
          }

      #custom-playerlabel {
        background: transparent;
        padding-left: 10px;
        padding-right: 5px;
        border-radius: 16px;
        margin-top: 5px;
        margin-bottom: 5px;
      }

      #window {
          background: #12162E;
          padding-left: 15px;
          padding-right: 15px;
          border-radius: 16px;
          margin-top: 5px;
          margin-bottom: 5px;
      }

      #cpu {
          background-color: #0c0e0f;
          border-radius: 16px;
          margin: 5px;
          margin-left: 5px;
          margin-right: 5px;
          padding: 0px 10px 0px 10px;
      }

      #memory {
          background-color: #101429;
          border-radius: 16px;
          margin: 5px;
          margin-left: 5px;
          margin-right: 5px;
          padding: 0px 10px 0px 10px;
      }

      #disk {
          background-color: #101429;
          border-radius: 16px;
          margin: 5px;
          margin-left: 5px;
          margin-right: 5px;
          padding: 0px 10px 0px 10px;
      }
    '';
  };
}
