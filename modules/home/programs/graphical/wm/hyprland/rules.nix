_: {
  wayland.windowManager.hyprland.settings = {
    layerrule = [
      # TODO Add some new rules
      # "noanim, launcher"
      # "ignorezero, launcher"
      # "blur, launcher"
    ];

    windowrule = [
      # Bitwarden Extension
      "match:title ^(.*Bitwarden Password Manager.*)$, float on"

      # Firefox/Zen
      "match:title ^(Picture-in-Picture)$, float on"
      "match:title ^(Picture-in-Picture)$, pin on"

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
