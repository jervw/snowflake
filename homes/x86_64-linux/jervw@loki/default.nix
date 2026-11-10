{
  lib,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) enabled;
in {
  nietos = {
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

    user = enabled;

    services = {
      ollama = enabled;
      syncthing = enabled;
      # voxtype = enabled; # disabled: fails to build
    };

    system = {
      xdg = enabled;
    };

    suites = {
      core = enabled;
      desktop = enabled;
      dev = enabled;
      gaming = enabled;
    };
  };

  wayland.windowManager.niri.settings.input.mouse.accel-profile = "flat";
}
