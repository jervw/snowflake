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

    services = {
      syncthing = enabled;
    };

    system = {
      xdg = enabled;
    };

    suites = {
      core = enabled;
      desktop = enabled;
      dev = enabled;
      gaming = {
        enable = true;
        enableEmulators = false;
      };
    };
  };

  wayland.windowManager.niri.settings = {
    input.mouse.accel-profile = "flat";
    _children = [
      {
        output = {
          _args = ["DP-1"];
          transform = "normal";
          mode = "2560x1440@164.999";
        };
      }
      {
        output = {
          _args = ["HDMI-A-1"];
          transform = "normal";
          position._props = {
            x = 2560;
            y = 0;
          };
        };
      }
    ];
  };
}
