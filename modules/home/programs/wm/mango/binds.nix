{
  config,
  namespace,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.wm.mango;
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
  # TODO: check whether empty space are allowed to make it more easier to read.
  wayland.windowManager.mango.settings = mkIf cfg.enable ''
    # Key Bindings
    # key name refer to `xev` or `wev` command output,
    # mod keys name: super,ctrl,alt,shift,none
    #

    # Programs
    bind=SUPER,Return,spawn,${defaults.terminal}
    bind=SUPER,D,spawn,${defaults.terminal}
    bind=SUPER,B,spawn,${defaults.browser}
    bind=SUPER,Z,spawn,grimblast --notify copysave area
    bind=SUPER+CTRL,Z,spawn,grimblast --notify copysave output
    bind=SUPER,P,spawn,hyprpicker -a | --autocopy


    # Essential
    # bind=SUPER+SHIFT,e,spawn,${noctaliaIpc ["sessionMenu" "toggle"]}
    bind=SUPER,q,killclient,
    bind=SUPER+SHIFT,r,reload_config


    # Switch window focus
    bind=SUPER,Tab,focusstack,next
    bind=SUPER,h,focusdir,left
    bind=SUPER,l,focusdir,right
    bind=SUPER,k,focusdir,up
    bind=SUPER,j,focusdir,down

    # Swap windows
    bind=SUPER+SHIFT,h,exchange_client,left
    bind=SUPER+SHIFT,l,exchange_client,right
    bind=SUPER+SHIFT,k,exchange_client,up
    bind=SUPER+SHIFT,j,exchange_client,down

    # Misc
    # bind=SUPER,Escape,toggleoverview,



    # switch window focus

    # swap window

    # switch window status
    bind=SUPER,g,toggleglobal,
    bind=ALT,backslash,togglefloating,
    bind=ALT,a,togglemaximizescreen,
    bind=ALT+SHIFT,f,togglefakefullscreen,
    bind=SUPER,i,minimized,
    bind=SUPER,o,toggleoverlay,
    bind=SUPER+SHIFT,I,restore_minimized
    bind=ALT,z,toggle_scratchpad

    # movewin
    bind=CTRL+SHIFT,Up,movewin,+0,-50
    bind=CTRL+SHIFT,Down,movewin,+0,+50
    bind=CTRL+SHIFT,Left,movewin,-50,+0
    bind=CTRL+SHIFT,Right,movewin,+50,+0

    # scroller layout
    bind=ALT,e,set_proportion,1.0
    bind=ALT,x,switch_proportion_preset,

    # switch layout
    bind=SUPER,n,switch_layout

    # tag switch
    bind=SUPER,Left,viewtoleft,0
    bind=CTRL,Left,viewtoleft_have_client,0
    bind=SUPER,Right,viewtoright,0
    bind=CTRL,Right,viewtoright_have_client,0
    bind=CTRL+SUPER,Left,tagtoleft,0
    bind=CTRL+SUPER,Right,tagtoright,0

    # Monitor switch
    bind=SUPER+Alt,h,focusmon,left
    bind=SUPER+Alt,l,focusmon,right

    bind=Ctrl,1,view,1,0
    bind=Ctrl,2,view,2,0
    bind=Ctrl,3,view,3,0
    bind=Ctrl,4,view,4,0
    bind=Ctrl,5,view,5,0

    # tag: move client to the tag and focus it
    # tagsilent: move client to the tag and not focus it
    # bind=Alt,1,tagsilent,1
    bind=Alt,1,tag,1,0
    bind=Alt,2,tag,2,0
    bind=Alt,3,tag,3,0
    bind=Alt,4,tag,4,0
    bind=Alt,5,tag,5,0

    # gaps
    bind=ALT+SHIFT,X,incgaps,1
    bind=ALT+SHIFT,Z,incgaps,-1
    bind=ALT+SHIFT,R,togglegaps

    # resizewin
    bind=CTRL+ALT,Up,resizewin,+0,-50
    bind=CTRL+ALT,Down,resizewin,+0,+50
    bind=CTRL+ALT,Left,resizewin,-50,+0
    bind=CTRL+ALT,Right,resizewin,+50,+0

    # Mouse Button Bindings
    # NONE mode key only work in ov mode
    mousebind=SUPER,btn_left,moveresize,curmove
    mousebind=SUPER,btn_right,moveresize,curresize

  '';
}
