{pkgs, ...}: let
  mkCommand = command: {
    command = [command];
  };
in {
  programs.niri = {
    enable = true;
    package = pkgs.niri;
    settings = {
      environment = {
        DISPLAY = ":0";
        NIXOS_OZONE_WL = "1";
      };

      spawn-at-startup = [
        (mkCommand "hyprlock")
        (mkCommand "nm-applet")
        (mkCommand "xwayland-satellite")
      ];

      input = {
        keyboard = {
          xkb = {
            layout = "us,fi";
            options = "grp:alt_shift_toggle";
          };
          repeat-delay = 200;
        };

        focus-follows-mouse.enable = true;
        warp-mouse-to-focus = true;
      };

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

      prefer-no-csd = true;
      hotkey-overlay.skip-at-startup = true;
    };
  };
}
