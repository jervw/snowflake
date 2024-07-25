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
          modules = [
            "clock"
            "hyprland/workspaces"
          ];
        };
        "custom/shutdown" = {
          format = "<span color='#ff5e5e'></span>";
          on-click = "systemctl poweroff";
          tooltip = false;
        };
        "custom/reboot" = {
          format = "<span color='#79b4fc'>󰑓</span>";
          on-click = "systemctl reboot";
          tooltip = false;
        };
        "custom/logout" = {
          format = "<span color='#63c773'>󰍃</span>";
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
          icon-size = 15;
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
          format = "<span color='#7AA2F7'> {temperatureC}°C  </span>";
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
          format-alt = "{:%A, %B %d, %Y (%R)}";
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
      @define-color accent #2362ba;
      * {
        font-family: "Noto Sans", "JetBrainsMono Nerd Font Mono";
        font-size: 16px;
        font-weight: 600;
        color: #DDDDDD;
        min-height: 0px;
        min-width: 0px;
      }
      tooltip {
        background-color: rgba(0,0,0,0.2);
        text-shadow: none;
      }
      #waybar {
        background: none;
      }
      .modules-left {
        background: rgba(0,0,0,0.3);
        border-radius: 0 0 15px 0;
        padding: 0 10px 0 0;
      }
      .modules-center {
        background: rgba(0,0,0,0.3);
        border-radius: 0 0 15px 15px;
        padding: 0 20px;
      }
      .modules-right {
        background: rgba(0,0,0,0.3);
        border-radius: 0 0 0 15px;
        padding: 0 0 0 10px;
      }
      #custom-nixos {
        margin: 0;
        font-size: 36px;
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
      }

      #clock {
        padding: 0;
        margin: 0;
        font-size: 18px;
      }

      #custom-reboot,
      #custom-logout,
      #custom-shutdown {
        padding: 0 13px 0 8px;
        margin-left: 4px;
        font-size: 18px;
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
        background-color: rgba(255,255,255,0.2);
      }

      #workspaces {
        margin: 2px;
      }

      #workspaces button {
        padding: 0px 3px;
        margin: 0px 3px;
        border-radius: 12px;
        background-color: #3b3b3b;
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

      #cpu,
      #network,
      #custom-notifications,
      #disk,
      #memory,
      #pulseaudio {
        padding: 0px 6px 0px 3px;
      }

      #memory {
        color: shade(#cca0e4, 0.8);
      }

      #disk {
        color: shade(#7aa2f7, 0.8);
      }

      #cpu {
        color: shade(#a6e3a1, 0.8);
      }

      #network {
        color: #a6e3a1;
      }

      #network.disabled,
      #network.disconnected {
        color: #d78787;
      }
      @keyframes blink {
        to {
          background-color: alpha(red, 0.6);
          color: @foreground;
        }
      }
      @keyframes blink-blue {
        to {
          background-color: alpha(#7aa2f7, 0.6);
          color: @foreground;
        }
      }
    '';
  };
}
