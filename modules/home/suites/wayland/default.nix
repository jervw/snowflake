{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkDefault;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.suites.wayland;
in {
  # This suite is mainly used for Wayland setups without a session/shell like Hyprland or Sway.
  options.${namespace}.suites.wayland = {
    enable = lib.mkEnableOption "wayland applications ";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      grimblast
      wl-clipboard
      wtype
      wlr-randr
      hyprpicker
      xorg.xeyes
      xorg.xrandr
      xclip
    ];

    snowflake = {
      programs = {
        graphical = {
          addons = {
            # hypridle = mkDefault enabled;
            wlsunset = mkDefault enabled;
          };
          bars = {
            noctalia = mkDefault enabled;
          };
        };
      };
    };
  };
}
