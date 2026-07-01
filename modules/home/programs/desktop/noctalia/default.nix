{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkForce;

  cfg = config.${namespace}.programs.desktop.noctalia;
in {
  options.${namespace}.programs.desktop.noctalia = {
    enable = lib.mkEnableOption "Enable Noctalia";
  };

  config = mkIf cfg.enable {
    programs.noctalia = {};

    programs.noctalia = {
      enable = true;
      settings = {
        audio = {
          enable_overdrive = true;
        };

        bar.default = {
          center = ["media"];
          end = ["tray" "notifications" "clipboard" "network" "volume" "battery" "control-center" "clock" "session"];
          margin_ends = 14;
          start = ["launcher" "workspaces"];
          thickness = 36;
          opacity = 0.84;
        };

        backdrop.enabled = true;

        location.auto_locate = true;

        nightlight = {
          enabled = true;
        };

        shell = {
          avatar_path = "/home/jervw/pics/.face.jpg";
          font_family = "JetBrainsMono Nerd Font";
          niri_overview_type_to_launch_enabled = true;
          screen_time_enabled = true;
        };

        theme = {
          mode = "dark";
          source = "wallpaper";
          wallpaper_scheme = "m3-content";

          templates = {
            builtin_ids = ["btop" "gtk3" "gtk4" "ghostty" "helix" "niri" "qt"];
            community_ids = ["zathura" "zed" "discord" "papirus-icons" "yazi"];
          };
        };

        wallpaper = {
          # default.path = "~/pics/wallpapers/default.jpeg";
          directory = "~/pics/wallpapers";
          automation.enabled = true;
        };

        widget = {
          network.show_label = false;
          tray.drawer = true;
          volume.show_label = false;
        };
      };
    };

    # Override programs to use noctalia colors
    programs = {
      helix.settings.theme = mkForce "noctalia";
      ghostty.settings.theme = mkForce "noctalia";
      zathura.extraConfig = "include noctaliarc";
      niri.settings.includes = [
        {
          path = "noctalia.kdl";
          optional = true;
        }
      ];
    };
  };
}
