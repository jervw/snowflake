{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.bars.waybar;
in {
  # TODO: Add monitor options
  options.${namespace}.programs.bars.waybar = {
    enable = lib.mkEnableOption "Enable waybar";
  };

  config = mkIf cfg.enable (
    let
      colors = config.lib.stylix.colors.withHashtag;
    in {
      programs.waybar = {
        enable = true;
        systemd = {
          enable = true;
          target = "graphical-session.target";
        };
        settings = {
          main = {
            layer = "top";
            position = "top";
            modules-left = [
              "group/powermenu"
              "group/workspace-container"
            ];
            modules-center = [
              "hyprland/window"
              "niri/window"
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
              };
            };
            "niri/window" = {
              format = "{}";
              icon = true;
              icon-size = 18;
              rewrite = {
                "(.*)Zen Browser" = "Zen Browser";
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
            "group/workspace-container" = {
              orientation = "horizontal";
              modules = [
                "hyprland/workspaces"
                "niri/workspaces"
              ];
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
            "niri/workspaces" = {
              format = "{icon}";
              format-icons = {
                urgent = "";
                active = "";
                default = "";
                sort-by-number = true;
              };
            };
            "niri/language" = {
              format = "{short}";
            };
            "tray" = {
              spacing = 8;
              icon-size = 18;
            };
            "group/scroll" = {
              orientation = "horizontal";
              modules = [
                "battery"
                "niri/language"
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
                "headphones" = " ";
                "handsfree" = " ";
                "headset" = " ";
                "phone" = " ";
                "portable" = " ";
                "car" = " ";
                "default" = [
                  " "
                  " "
                ];
              };
              on-click = "pavucontrol";
              smooth-scrolling-threshold = 1;
            };
            "network" = {
              interval = 2;
              format-wifi = " {bandwidthDownBits} ";
              format-ethernet = " {bandwidthDownBits} 󰈀";
              format-disconnected = "󰈂";
              format-linked = " ";
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
              format = "{usage}% ";
            };
            "temperature" = {
              interval = 1;
              hwmon-path = ["/sys/class/hwmon/hwmon0/temp1_input" "/sys/class/hwmon/hwmon1/temp1_input" "/sys/class/hwmon/hwmon2/temp1_input" "/sys/class/hwmon/hwmon3/temp1_input"];
              format = "{temperatureC} °C ";
              tooltip-format = "Core Temp: {temperatureC}°C ";
            };
            "custom/nixos" = {
              on-click = "fuzzel";
              format = "<span color='${colors.base0D}'> </span>";
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
                  "today" = "<span color='${colors.base0D}'><b><u>{}</u></b></span>";
                };
              };
            };
            "battery" = {
              format = "{capacity}% {icon}";
              format-icons = ["" "" "" "" ""];
              max-length = 25;
            };
          };
        };

        style = ''
          @define-color background ${colors.base00};
          @define-color foreground ${colors.base05};
          @define-color accent ${colors.base0D};
          @define-color tooltip ${colors.base00};
          @define-color hover ${colors.base00};
          @define-color red ${colors.base08};
          @define-color green ${colors.base0B};
          @define-color blue ${colors.base0D};
          @define-color yellow ${colors.base0A};
          @define-color purple ${colors.base0E};

          * {
            font-family: "Noto Sans", "JetBrainsMono Nerd Font Propo";
            font-size: 16px;
            font-weight: 600;
            color: @foreground;
            min-height: 0px;
            min-width: 0px;
          }
          tooltip {
            background-color: alpha(@tooltip, 0.2);
            text-shadow: none;
          }
          #waybar {
            background: none;
          }
          .modules-left {
            background: alpha(@background, 0.7);
            border-radius: 0 0 15px 0;
            padding: 0 10px 0 0;
          }
          .modules-center {
            background: alpha(@background, 0.7);
            border-radius: 0 0 15px 15px;
            padding: 0 20px;
          }
          .modules-right {
            background: alpha(@background, 0.7);
            border-radius: 0 0 0 15px;
            padding: 0 0 0 10px;
          }
          #custom-nixos {
            margin-left: 10px;
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
          #battery,
          #pulseaudio {
            margin-top: 2px;
            margin-bottom: 2px;
            transition: background-color 200ms;
          }
          #custom-notification:hover,
          #cpu:hover,
          #memory:hover,
          #network:hover,
          #battery:hover,
          #temperature:hover,
          #pulseaudio:hover {
            transition: background-color 200ms;
            background-color: alpha(@hover, 0.5);
          }

          #workspaces {
            margin: 0;
            padding: 10px 10px 10px 0;
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
          #battery,
          #custom-notifications,
          #temperature,
          #memory,
          #language,
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
  );
}
