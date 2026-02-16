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
  # This suite is mainly used for Wayland setups without a session/shell like Hyprland or Niri.
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

    home.sessionVariables = {
      QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
      NIXOS_OZONE_WL = 1;
    };

    snowflake = {
      programs = {
        addons = {
          hypridle = mkDefault enabled;
        };
        bars = {
          noctalia = mkDefault enabled;
        };
      };
    };
  };
}
