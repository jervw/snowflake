{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) enabled;
in {
  snowflake = {
    user = {
      enable = true;
      inherit (config.snowfallorg.user) name;
    };

    programs = {
      graphical.wm.hyprland = enabled;
    };

    services = {
      syncthing = enabled;
    };

    system = {
      xdg = enabled;
    };

    suites = {
      core = enabled;
      desktop = enabled;
      gaming = enabled;
      wayland = enabled;
    };

    theme = {
      stylix = enabled;
    };
  };

  #
  programs.niri.settings = {
    input.mouse.accel-profile = "flat";
    outputs = {
      "DP-1" = {
        mode = {
          width = 2560;
          height = 1440;
          refresh = 164.999;
        };
      };
      "HDMI-A-1" = {
        position = {
          x = 2560;
          y = 0;
        };
      };
    };
  };

  wayland.windowManager.hyprland.settings = {
    monitor = [
      ",highrr,auto,1"
      "HDMI-A-1,preferred,auto-left,1"
    ];
    workspace = [
      "1, monitor:HDMI-A-1, gapsin:5, gapsout:5, default:true"
      "2, monitor:DP-1, default:true"
      "3, monitor:DP-1"
      "4, monitor:DP-1"
      "5, monitor:DP-1"
    ];
    cursor = {
      default_monitor = "DP-1";
    };
    input = {
      force_no_accel = true;
    };
  };
}
