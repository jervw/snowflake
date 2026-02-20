{
  config,
  namespace,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.${namespace}.programs.wm.mango;
  inherit (config.${namespace}.programs) defaults;
  workspaces = builtins.concatStringsSep "\n" (builtins.genList (
      x: let
        ws = toString (x + 1);
      in ''
        bind=SUPER,${ws},view,${ws},0
        bind=SUPER+SHIFT,${ws},tag,${ws},0
      ''
    )
    5);
  noctaliaIpc = args: "noctalia-shell ipc call ${lib.concatStringsSep " " args}";
in {
  wayland.windowManager.mango.settings = mkIf cfg.enable ''
    exec-once="dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots"
    exec-once="uwsm finalize"
    # Monitor rules
    monitorrule=name:DP-1,width:2560,height:1440,refresh:165,x:1920,y:0
    monitorrule=name:HDMI-A-1,width:1920,height:1080,refresh:60,x:0,y:0

    # Programs
    bind=SUPER,Return,spawn,ghostty
    bind=SUPER,D,spawn,${defaults.launcher}
    bind=SUPER,B,spawn,brave

    # Essential
    bind=SUPER+SHIFT,E,spawn,${noctaliaIpc ["sessionMenu" "toggle"]}
    bind=SUPER,Q,killclient
    bind=SUPER,F,togglemaximizescreen
    bind=SUPER+SHIFT,F,togglefakefullscreen
    bind=SUPER,space,togglefloating,
    bind=SUPER+SHIFT,R,reload_config

    # Move window focus (vim)
    bind=SUPER,H,focusdir,left
    bind=SUPER,L,focusdir,right
    bind=SUPER,K,focusdir,up
    bind=SUPER,J,focusdir,down
    bind=SUPER,Tab,focusstack,next

    # Move windows (vim)
    bind=SUPER+SHIFT,H,exchange_client,left
    bind=SUPER+SHIFT,L,exchange_client,right
    bind=SUPER+SHIFT,K,exchange_client,up
    bind=SUPER+SHIFT,J,exchange_client,down

    # Resize windows
    bind=SUPER+CTRL,H,resizewin,-50,+0
    bind=SUPER+CTRL,L,resizewin,+50,+0
    bind=SUPER+CTRL,K,resizewin,+0,-50
    bind=SUPER+CTRL,J,resizewin,+0,+50

    # Move floating windows (vim)
    bind=SUPER+ALT,H,movewin,-50,+0
    bind=SUPER+ALT,L,movewin,+50,+0
    bind=SUPER+ALT,K,movewin,+0,-50
    bind=SUPER+ALT,J,movewin,+0,+50

    # Scratchpad / overlay
    bind=SUPER,T,toggle_scratchpad
    bind=SUPER+SHIFT,T,minimized

    # Overview
    bind=SUPER,Escape,toggleoverview,

    # Misc
    # bind=SUPER,G,spawn,${noctaliaIpc ["wallpaper" "random"]}
    bind=SUPER+SHIFT,G,toggleglobal,
    bind=SUPER,I,minimized,
    bind=SUPER+SHIFT,I,restore_minimized,
    bind=SUPER,g,switch_layout,

    # Tags (generated: SUPER,1-5 view / SUPER+SHIFT,1-5 move)
    ${workspaces}

    # Monitor focus
    bind=SUPER,comma,focusmon,left
    bind=SUPER,period,focusmon,right

    # Scroller layout
    bind=SUPER,E,set_proportion,1.0
    bind=SUPER+SHIFT,E,switch_proportion_preset,

    # Media keys
    bind=NONE,XF86AudioPlay,spawn,${noctaliaIpc ["media" "playPause"]}
    bind=NONE,XF86AudioPrev,spawn,${noctaliaIpc ["media" "previous"]}
    bind=NONE,XF86AudioNext,spawn,${noctaliaIpc ["media" "next"]}
    bind=NONE,XF86AudioRaiseVolume,spawn,${noctaliaIpc ["volume" "increase"]}
    bind=NONE,XF86AudioLowerVolume,spawn,${noctaliaIpc ["volume" "decrease"]}

    # Mouse
    mousebind=SUPER,btn_left,moveresize,curmove
    mousebind=SUPER,btn_right,moveresize,curresize
  '';
}
