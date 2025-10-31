{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.graphical.wm.niri;

  mkMatchRule = {
    appId,
    title ? "",
    openFloating ? false,
  }: let
    baseRule = {
      matches = [
        {
          app-id = appId;
          inherit title;
        }
      ];
    };
    floatingRule =
      if openFloating
      then {open-floating = true;}
      else {};
  in
    baseRule // floatingRule;

  openFloatingAppIds = [
    "org.pulseaudio.pavucontrol"
    "^(Volume Control)"
    "^(dialog)"
    "^(file_progress)"
    "^(confirm)"
    "^(download)"
    "^(error)"
    "^(notification)"
  ];

  floatingRules = builtins.map (appId:
    mkMatchRule {
      inherit appId;
      openFloating = true;
    })
  openFloatingAppIds;

  windowRules = [
    {
      geometry-corner-radius = let
        radius = 16.0;
      in {
        bottom-left = radius;
        bottom-right = radius;
        top-left = radius;
        top-right = radius;
      };
      clip-to-geometry = true;
      draw-border-with-background = false;
    }
    {
      matches = [
        {is-floating = true;}
      ];
      shadow.enable = true;
    }
    {
      matches = [
        {is-window-cast-target = true;}
      ];
    }
    {
      matches = [
        {app-id = "^(zen|firefox||zen-.*)$";}
      ];
      open-maximized = true;
    }
    {
      matches = [
        {
          app-id = "firefox$";
          title = "^Picture-in-Picture$";
        }
        {
          app-id = "zen-.*$";
          title = "^Picture-in-Picture$";
        }
        {title = "^Picture in picture$";}
        {title = "^Discord Popout$";}
      ];
      open-floating = true;
      default-floating-position = {
        x = 32;
        y = 32;
        relative-to = "top-right";
      };
    }
  ];
in
  mkIf cfg.enable {
    programs.niri.settings = {
      window-rules = windowRules ++ floatingRules;
      layer-rules = [
        {
          matches = [{namespace = "^hyprpaper$";}];
          # TODO this niri flake settings module is not up to date as below does not exist
          # place-within-backdrop = true;
        }
      ];
    };
  }
