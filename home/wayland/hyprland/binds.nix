_: let
  term = "foot";
  workspaces = builtins.concatLists (builtins.genList (
      x: let
        ws = toString (x + 1);
      in [
        "$MOD, ${ws}, workspace, ${ws}"
        "$MOD SHIFT, ${ws}, movetoworkspacesilent, ${ws}"
      ]
    )
    5);
in {
  wayland.windowManager.hyprland.settings = {
    # Mod key
    "$MOD" = "SUPER";

    binds = {
      movefocus_cycles_fullscreen = false;
    };

    bind =
      [
        # Programs
        "$MOD, Return, exec, ${term}"
        "$MOD, D, exec, pkill fuzzel || fuzzel"
        "$MOD, V, exec, ${term} -e yazi"
        "$MOD, B, exec, zen"
        "$MOD, Z, exec, grimblast --notify copysave area"
        "$MOD CTRL, Z, exec, grimblast --notify copysave output"
        "$MOD, C, exec, clipman pick --tool=CUSTOM --tool-args='fuzzel -d'"
        "$MOD, M, exec, bemoji -t"
        "$MOD, Y, exec, uuctl"
        "$MOD, P, exec, hyprpicker -a | --autocopy"
        "$MOD, Escape, exec, missioncenter"

        # Essential
        "$MOD SHIFT, E, exit"
        "$MOD, Q, killactive"
        "$MOD, F, fullscreen"
        "$MOD, Space, togglefloating"
        "$MOD, S, togglesplit"

        # Move window focus
        "$MOD, H, movefocus, l"
        "$MOD, L, movefocus, r"
        "$MOD, K, movefocus, u"
        "$MOD, J, movefocus, d"

        # Move windows
        "$MOD SHIFT, H, movewindow, l"
        "$MOD SHIFT, L, movewindow, r"
        "$MOD SHIFT, K, movewindow, u"
        "$MOD SHIFT, J, movewindow, d"

        # Misc
        "$MOD, Tab, changegroupactive"
        "$MOD, G, togglegroup"
        "$MOD, T, togglespecialworkspace"
        "$MOD SHIFT, T, movetoworkspacesilent, special"
      ]
      ++ workspaces;

    binde = [
      "$MOD CTRL, H, resizeactive, -50 0"
      "$MOD CTRL, L, resizeactive, 50 0"
      "$MOD CTRL, K, resizeactive, 0 -50"
      "$MOD CTRL, J, resizeactive, 0 50"
    ];
    bindm = [
      "$MOD, mouse:272, movewindow"
      "$MOD, mouse:273, resizewindow"
    ];
    bindl = [
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
    ];
    bindle = [
      ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise --max-volume 120"
      ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower --max-volume 120"
    ];
  };
}
