{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) enabled;
in {
  snowflake = {
    monitors = {
      "DP-1" = {
        transform = "normal";
        mode = {
          width = 2560;
          height = 1440;
          refreshRate = 164.999;
        };
      };

      "HDMI-A-1" = {
        transform = "normal";
        position = {
          x = 2560;
          y = 0;
        };
      };
    };

    user = {
      enable = true;
      inherit (config.snowfallorg.user) name;
    };

    services = {
      ollama = enabled;
      syncthing = enabled;
      voxtype = enabled;
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
        enableEmulators = true;
      };
    };
  };

  wayland.windowManager.niri.settings.input.mouse.accel-profile = "flat";
}
