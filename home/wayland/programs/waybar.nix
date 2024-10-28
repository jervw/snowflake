_: {
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };
    settings = {
      main = {
        layer = "top";
        position = "top";
        output = "!HDMI-A-1";
        modules-left = [
          "group/powermenu"
          "group/stuff"
        ];
        modules-center = [
          "hyprland/window"
        ];
        modules-right = [
          "tray"
          "group/scroll"
          "group/hardware"
        ];
        "hyprland/window" = {
          format = "{}";
          icon = true;
          icon-size = 18;
          rewrite = {
            "(.*)Zen Browser" = "Zen Browser";
            "(.*)Mozilla Firefox" = "Mozilla Firefox";
          };
        };
        "group/powermenu" = {
          drawer = {
            "children-class" = "power-menu";
            "transition-duration" = 500;
            "transition-left-to-right" = true;
          };
          orientation = "horizontal";
          modules = [
            "custom/nixos"
            "custom/shutdown"
            "custom/reboot"
            "custom/logout"
          ];
        };
        "group/stuff" = {
          orientation = "horizontal";
          modules = ["hyprland/workspaces"];
        };
        "custom/shutdown" = {
          format = "";
          on-click = "systemctl poweroff";
          tooltip = false;
        };
        "custom/reboot" = {
          format = "󰑓";
          on-click = "systemctl reboot";
          tooltip = false;
        };
        "custom/logout" = {
          format = "󰍃";
          on-click = "hyprctl dispatch exit";
          tooltip = false;
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

        "tray" = {
          spacing = 8;
          icon-size = 18;
        };
        "group/scroll" = {
          orientation = "horizontal";
          modules = [
            "pulseaudio"
            "clock"
          ];
        };
        "group/hardware" = {
          drawer = {
            "children-class" = "fancy-stuff";
            "transition-duration" = 500;
            "transition-left-to-right" = false;
          };
          orientation = "horizontal";
          "modules" = [
            "custom/notification"
            "network"
            "memory"
            "cpu"
            "temperature"
          ];
        };
        "pulseaudio" = {
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}";
          format-muted = "󰝟 ";
          format-icons = {
            "headphones" = "  ";
            "handsfree" = "  ";
            "headset" = "  ";
            "phone" = "  ";
            "portable" = "  ";
            "car" = "  ";
            "default" = [
              "  "
              "  "
            ];
          };
          on-click = "pavucontrol";
          smooth-scrolling-threshold = 1;
        };
        "network" = {
          interval = 2;
          format-wifi = "   {bandwidthDownBits}";
          format-ethernet = " 󰈀  {bandwidthDownBits}";
          format-disconnected = "󰈂";
          format-linked = "";
          tooltip-format = "{ipaddr}";
          tooltip-format-wifi = "{essid} ({signalStrength}%)   \n{ipaddr} | {frequency} MHz{icon} \n {bandwidthDownBits}  {bandwidthUpBits} ";
          tooltip-format-ethernet = "{ifname} 󰈀 \n{ipaddr} | {frequency} MHz{icon} \n󰈀 {bandwidthDownBits}  {bandwidthUpBits} ";
          tooltip-format-disconnected = "No connection";
        };
        "memory" = {
          format = "{}% ";
          interval = 1;
        };
        "cpu" = {
          interval = 1;
          format = "{usage}%  ";
        };
        "temperature" = {
          interval = 1;
          hwmon-path = ["/sys/class/hwmon/hwmon0/temp1_input" "/sys/class/hwmon/hwmon1/temp1_input" "/sys/class/hwmon/hwmon2/temp1_input" "/sys/class/hwmon/hwmon3/temp1_input"];
          format = "{temperatureC} °C  ";
          tooltip-format = "Core Temp: {temperatureC}°C ";
        };
        "custom/nixos" = {
          on-click = "fuzzel";
          format = "<span color='#7FB6E1'> </span>";
          tooltip = false;
        };
        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            "notification" = "󱅫";
            "none" = "󰂚";
            "dnd-notification" = "󰂛";
            "dnd-none" = "󰂛";
            "inhibited-notification" = "󱅫";
            "inhibited-none" = "󰂚";
            "dnd-inhibited-notification" = "󰂛";
            "dnd-inhibited-none" = "󰂛";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "sleep 0.1 && swaync-client -t -sw";
          on-click-right = "sleep 0.1 && swaync-client -d -sw";
          escape = false;
        };
        "clock" = {
          format = "{:%H:%M}";
          format-alt = "{:%A, %B %d, %Y}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            "mode" = "month";
            "mode-mon-col" = 3;
            "weeks-pos" = "right";
            "on-scroll" = 1;
            "on-click-right" = "mode";
            "format" = {
              "today" = "<span color='#a6e3a1'><b><u>{}</u></b></span>";
            };
          };
        };
      };
    };

    style = ''
      @define-color background rgba(40, 44, 52, 0.7);
      @define-color foreground rgba(221, 221, 221, 1);
      @define-color accent rgba(127, 182, 225, 1);
      @define-color tooltip rgba(0, 0, 0, 0.2);
      @define-color hover rgba(40, 44, 52, 0.5);
      @define-color red rgba(208, 114, 119, 1);
      @define-color green rgba(161, 193, 129, 1);
      @define-color blue rgba(115, 173, 233, 1);
      @define-color yellow rgba(223, 193, 132, 1);
      @define-color purple rgba(180, 119, 207, 1);

      * {
        font-family: "Noto Sans", "JetBrainsMono Nerd Font Propo";
        font-size: 16px;
        font-weight: 600;
        color: @foreground;
        min-height: 0px;
        min-width: 0px;
      }
      tooltip {
        background-color: @tooltip;
        text-shadow: none;
      }
      #waybar {
        background: none;
      }
      .modules-left {
        background: @background;
        border-radius: 0 0 15px 0;
        padding: 0 10px 0 0;
      }
      .modules-center {
        background: @background;
        border-radius: 0 0 15px 15px;
        padding: 0 20px;
      }
      .modules-right {
        background: @background;
        border-radius: 0 0 0 15px;
        padding: 0 0 0 10px;
      }
      #custom-nixos {
        margin: 0 -10px 0 10px;
        padding: 0;
        font-size: 24px;
      }
      #window {
        opacity: 100;
        transition: opacity 1s ease-in-out
      }
      window#waybar.empty #window {
        opacity: 0;
      }
      window#waybar.empty .modules-center {
        background: none;
      }
      @keyframes gradient {
      	0% {
      		background-position: 100% 0%;
      	}
      	100% {
      		background-position: 15% 100%;
      	}
      }

      #custom-notification,
      #tray {
        padding: 0px 12px 0px;
        font-size: 24px;
      }

      #clock {
        padding: 0;
        margin: 0;
      }

      #custom-reboot,
      #custom-logout,
      #custom-shutdown {
        padding: 0 10px 0 10px;
        margin-right: 5px;
        font-size: 24px;
      }

      #custom-reboot {
        color: @blue;
      }
      #custom-logout {
        color: @green;
      }
      #custom-shutdown {
        color: @red;
      }

      #custom-notification,
      #cpu,
      #network,
      #pulseaudio {
        margin-top: 2px;
        margin-bottom: 2px;
        transition: background-color 200ms;
      }
      #custom-notification:hover,
      #cpu:hover,
      #memory:hover,
      #network:hover,
      #temperature:hover,
      #pulseaudio:hover {
        transition: background-color 200ms;
        background-color: @hover;
      }

      #workspaces {
        margin: 0;
        padding: 10px
      }

      #workspaces button {
        padding: 0px 3px;
        margin: 0px 3px;
        border-radius: 16px;
        background-color: @accent;
        min-width: 15px;
        min-height: 12px;
        transition: all 200ms ease-in-out;
        opacity: 0.5;
      }

      #workspaces button.active {
        min-width: 35px;
        opacity: 0.8;
      }

      #workspaces button.urgent {
        background-color: @red;
        opacity: 1;
      }

      #cpu,
      #network,
      #custom-notifications,
      #temperature,
      #memory,
      #pulseaudio {
        padding: 0px 6px 0px 3px;
      }

      #memory {
        color: @yellow;
      }

      #cpu {
        color: @blue;
      }

      #network {
        color: @green;
      }

      #temperature {
        color: @purple;
      }

      #network.disabled,
      #network.disconnected {
        color: @red;
      }
    '';
  };
}
