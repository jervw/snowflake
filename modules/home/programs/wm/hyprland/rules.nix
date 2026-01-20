{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.wm.hyprland;
in {
  wayland.windowManager.hyprland.settings = mkIf cfg.enable {
    layerrule = [
      # TODO Add some new rules
      # "noanim, launcher"
      # "ignorezero, launcher"
      # "blur, launcher"
    ];

    windowrule = [
      # Bitwarden
      "match:title ^(.*Bitwarden Password Manager.*)$, float on"
      "match:title ^(Picture in picture)$, float on"
      "match:title ^(Picture in picture)$, pin on"
      "match:title Bitwarden, float on"

      # MPV
      "match:class mpv, float on"

      # Idle inhibit
      "match:class ^(mpv)$, idle_inhibit focus"
      "match:class ^(zen)$, match:title ^(.*YouTube.*)$, idle_inhibit focus"
      "match:class ^(zen)$, idle_inhibit fullscreen"

      "match:class Cider, workspace special"
      "match:class vesktop, workspace 1 silent"

      # Dim stuff
      "match:class ^(gcr-prompter)$, dim_around on"
      "match:class ^(xdg-desktop-portal-gtk)$, dim_around on"
      "match:class ^(zen)$, match:title ^(File Upload)$, dim_around on"
      "match:class ^(polkit-gnome-authentication-agent-1)$, dim_around on"
    ];
  };
}
