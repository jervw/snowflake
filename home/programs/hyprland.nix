_: let
  term = "ghostty";

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
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd = {
      enableXdgAutostart = true;
      variables = ["--all"];
    };

    settings = {
      "$MOD" = "SUPER";
      exec-once = [
        "hyprlock"
        "nm-applet"
        "eval $(gnome-keyring-daemon --start --components=secrets)"
      ];

      general = {
        gaps_in = 12;
        gaps_out = 10;
        allow_tearing = true;
        border_size = 3;
      };

      group = {
        groupbar = {
          height = 20;
          font_size = 12;
        };
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      render = {
        explicit_sync = 1;
      };

      opengl = {
        nvidia_anti_flicker = false;
      };

      input = {
        kb_layout = "us,fi";
        kb_options = "grp:alt_shift_toggle";
        repeat_delay = 200;
      };

      misc = {
        disable_autoreload = true;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        animate_manual_resizes = true;
        key_press_enables_dpms = true;
        vrr = 1;
      };

      ecosystem.no_update_news = true;

      decoration = {
        rounding = 15;
        rounding_power = 4.0;
        blur = {
          enabled = true;
          size = 5;
          passes = 2;
        };
        shadow = {
          enabled = true;
          range = 4;
          offset = "2 2";
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "overshot, 0.05, 0.9, 0.1, 1.05"
          "smoothOut, 0.36, 0, 0.66, -0.56"
          "smoothIn, 0.25, 1, 0.5, 1"
        ];
        animation = [
          "windows, 1, 5, default"
          "windowsOut, 1, 4, default"
          "windowsMove, 1, 4, default"
          "border, 0"
          "workspaces, 1, 6, default"
        ];
      };

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
        "workspace special, class:(cider)"
      ];

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
          "$MOD, Z, exec, grimblast --notify --cursor copysave area"
          "$MOD CTRL, Z, exec, grimblast --notify --cursor copysave output"
          "$MOD, C, exec, clipman pick --tool=CUSTOM --tool-args='fuzzel -d'"
          "$MOD, M, exec, bemoji -t"
          "$MOD, M, exec, bemoji -t"
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
  };
}
