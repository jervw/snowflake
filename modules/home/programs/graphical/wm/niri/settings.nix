_: let
  mkCommand = command: {
    command = [command];
  };
in {
  programs.niri = {
    settings = {
      environment = {
        DISPLAY = ":0";
        NIXOS_OZONE_WL = "1";
      };

      spawn-at-startup = [
        (mkCommand "hyprlock")
        (mkCommand "xwayland-satellite")
      ];

      input = {
        keyboard = {
          xkb = {
            layout = "us,fi";
            options = "caps:none,grp:alt_shift_toggle";
          };
          repeat-delay = 200;
        };

        focus-follows-mouse.enable = true;
        warp-mouse-to-focus = true;
      };

      prefer-no-csd = true;
      hotkey-overlay.skip-at-startup = true;
    };
  };
}
