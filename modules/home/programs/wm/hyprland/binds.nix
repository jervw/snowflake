{
  config,
  namespace,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.wm.hyprland;
  inherit (config.${namespace}.programs) defaults;
  workspaces = builtins.concatLists (builtins.genList (
      x: let
        ws = toString (x + 1);
      in [
        "$MOD, ${ws}, workspace, ${ws}"
        "$MOD SHIFT, ${ws}, movetoworkspacesilent, ${ws}"
      ]
    )
    5);

  noctaliaIpc = args: "noctalia-shell ipc call ${lib.concatStringsSep " " args}";
in {
  wayland.windowManager.hyprland.settings = mkIf cfg.enable {
    # Mod key
    "$MOD" = "SUPER";

    binds = {
      movefocus_cycles_fullscreen = false;
    };

    bind =
      [
        # Programs
        "$MOD, Return, exec, ${defaults.terminal}"
        "$MOD, Tab, global, com.mitchellh.ghostty:LOGO+Tab"
        "$MOD, D, exec, ${defaults.launcher}"
        "$MOD, Y, exec, ${defaults.terminal} -e yazi"
        "$MOD, B, exec, ${defaults.browser}"
        "$MOD, Z, exec, grimblast --notify copysave area"
        "$MOD CTRL, Z, exec, grimblast --notify copysave output"
        "$MOD, P, exec, hyprpicker -a | --autocopy"

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
        "$MOD, T, togglespecialworkspace"
        "$MOD SHIFT, T, movetoworkspacesilent, special"
        "$MOD SHIFT, Escape, exec, ${noctaliaIpc ["sessionMenu" "toggle"]}"

        # Plugins
        # "$MOD, Escape, hyprexpo:expo, toggle"
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
      ", XF86AudioPlay, exec, ${noctaliaIpc ["media" "playPause"]}"
      ", XF86AudioPrev, exec, ${noctaliaIpc ["media" "previous"]}"
      ", XF86AudioNext, exec, ${noctaliaIpc ["media" "next"]}"
    ];
    bindle = [
      ", XF86AudioRaiseVolume, exec, ${noctaliaIpc ["volume" "increase"]}"
      ", XF86AudioLowerVolume, exec, ${noctaliaIpc ["volume" "decrease"]}"
    ];
  };
}
