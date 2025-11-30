{
  config,
  lib,
  pkgs,
  inputs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.graphical.bars.noctalia;
  defaults = config.${namespace}.programs.defaults;
in {
  options.${namespace}.programs.graphical.bars.noctalia = {
    enable = lib.mkEnableOption "Enable Noctalia";
  };

  config = mkIf cfg.enable {
    programs.noctalia-shell = {
      enable = true;
      package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
      systemd.enable = true;
      settings = {
        general = {
          avatarImage = "/home/jervw/.face";
        };
        ui = {
          settingsPanelAttachToBar = true;
        };
        audio = {
          volumeOverdrive = true;
        };
        sessionMenu = {
          enableCountdown = false;
        };
        brightness = {
          enableDdcSupport = true;
        };

        bar = {
          density = "comfortable";
          position = "top";
          showCapsule = true;
          floating = true;
          outerCorners = false;
          marginVertical = 0.25;
          marginHorizontal = 0.50;
          widgets = {
            left = [
              {
                id = "Workspace";
                labelMode = "index";
                hideUnoccupied = false;
              }
            ];
            center = [
              {
                id = "MediaMini";
                showAlbumArt = true;
                showVisualizer = true;
              }
            ];
            right = [
              {
                id = "Tray";
                drawerEnabled = false;
              }
              {
                id = "VPN";
              }
              {
                id = "NotificationHistory";
              }
              {
                id = "Volume";
              }
              {
                id = "Clock";
              }
              {
                id = "ControlCenter";
              }
            ];
          };
        };
        wallpaper = {
          overviewEnabled = true;
          directory = "/home/jervw/pics/wallpapers";
          defaultWallpaper = "/home/jervw/pics/wallpapers/default.png";
          randomEnabled = true;
          randomIntervalSec = 1800;
        };
        appLauncher = {
          terminalCommand = "${defaults.terminal} -e";
        };
        location .name = "Helsinki, Finland";
        dock.enabled = false;
      };
    };

    snowflake = {
      programs = {
        defaults = {
          launcher = "noctalia-shell ipc call launcher toggle";
          lock = "noctalia-shell ipc call lockScreen lock";
        };
      };
    };
  };
}
