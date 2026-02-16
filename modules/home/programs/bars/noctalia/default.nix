{
  config,
  lib,
  pkgs,
  inputs,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkForce;

  cfg = config.${namespace}.programs.bars.noctalia;
in {
  options.${namespace}.programs.bars.noctalia = {
    enable = lib.mkEnableOption "Enable Noctalia";
  };

  config = mkIf cfg.enable {
    programs.noctalia-shell = {
      enable = true;
      package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
      systemd.enable = true;
      settings = {
        general = {
          avatarImage = "/home/jervw/pics/.face";
        };
        ui = {
          fontDefault = "JetBrainsMono Nerd Font";
          fontFixed = "JetBrainsMono Nerd Font";
          settingsPanelAttachToBar = true;
        };
        audio = {
          volumeOverdrive = true;
        };
        network = {
          wifiEnabled = false;
        };
        nightLight = {
          enabled = true;
        };

        sessionMenu = {
          largeButtonsStyle = true;
          enableCountdown = false;
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
                maxWidth = 200;
              }
            ];
            right = [
              {
                id = "Tray";
                drawerEnabled = false;
              }
              {
                id = "plugin:tailscale";
              }
              {
                id = "plugin:privacy-indicator";
                hideInactive = true;
                removeMargins = true;
              }
              {id = "VPN";}
              {id = "NotificationHistory";}
              {id = "Network";}
              {id = "Volume";}
              {id = "Battery";}
              {
                id = "Clock";
                usePrimaryColor = true;
              }
              {
                id = "ControlCenter";
                useDistroLogo = true;
                colorizeDistroLogo = true;
                colorizeSystemIcon = "primary";
                enableColorization = true;
              }
            ];
          };
        };
        wallpaper = {
          overviewEnabled = true;
          directory = "/home/jervw/pics/wallpapers";
          randomEnabled = true;
          randomIntervalSec = 1800;
        };
        appLauncher = {
          terminalCommand = "ghostty -e";
          enableClipboardHistory = true;
          customLaunchPrefixEnabled = true;
          customLaunchPrefix = "uwsm app --";
        };
        location .name = "Helsinki, Finland";
        dock.enabled = false;

        colorSchemes.useWallpaperColors = true;
        templates = {
          discord = true;
          ghostty = true;
          gtk = true;
          helix = true;
          qt = true;
          yazi = true;
          hyprtoolkit = true;
          zathura = true;
        };
      };
    };

    # Override programs to use noctalia colors
    programs = {
      helix.settings.theme = mkForce "noctalia";
      ghostty.settings.theme = mkForce "noctalia";
      zathura.extraConfig = "include noctaliarc";
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
