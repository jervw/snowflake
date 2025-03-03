_: {
  wayland.windowManager.hyprland.settings = {
    layerrule = [
      "ignorezero, waybar"
      "blur, waybar"
      "noanim, launcher"
      "ignorezero, launcher"
      "blur, launcher"
    ];

    windowrulev2 = [
      "noshadow, floating:0"
      "suppressevent maximize, class:^(zen)$"
      "float, title:^(Volume Control)$"
      "size 900 500, title:^(Volume Control)$"
      "float, class:mpv"
      "float, class:^(zen)$, title:^(Picture-in-Picture)$"
      "pin, class:^(zen)$, title:^(Picture-in-Picture)$"
      "size 800 450, class:^(zen)$, title:^(Picture-in-Picture)$"
      "workspace 1, class:(vesktop)"
      "workspace special, class:(Cider)"
    ];
  };
}
