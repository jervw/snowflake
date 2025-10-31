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
in {
  options.${namespace}.programs.graphical.bars.noctalia = {
    enable = lib.mkEnableOption "Enable Noctalia";
  };

  config = mkIf cfg.enable {
    programs.noctalia-shell = {
      enable = true;
      package = inputs.noctalia.packages.${pkgs.system}.default;
      settings = {
        bar = {
          density = "compact";
          position = "top";
          showCapsule = true;
          floating = true;
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
        colorSchemes.predefinedScheme = "Monochrome";
        general = {
          avatarImage = "/home/jervw/.face";
        };
        location = {
          name = "Helsinki, Finland";
        };
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
