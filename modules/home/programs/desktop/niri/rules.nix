{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.${namespace}.programs.desktop.niri;

  # Default styling applied to all windows
  defaultWindowStyle = {
    draw-border-with-background = false;
    geometry-corner-radius = [16.0 16.0 16.0 16.0];
    clip-to-geometry = true;
    background-effect = {
      blur = true;
      xray = false;
    };
  };

  # Screencast indicator colors
  screencastColor = {
    active = "#f38ba8";
    inactive = "#7d0d2d";
  };

  # Rules for specific window conditions
  conditionRules = [
    # Indicate screencasted windows
    {
      match._props.is-window-cast-target = true;
      focus-ring = {
        active-color = screencastColor.active;
        inactive-color = screencastColor.inactive;
      };
      border.inactive-color = screencastColor.inactive;
      shadow.color = "${screencastColor.inactive}70";
      tab-indicator = {
        active-color = screencastColor.active;
        inactive-color = screencastColor.inactive;
      };
    }

    # Picture in picture window
    {
      match._props.title = "^Picture in picture$";
      open-floating = true;
      default-floating-position._props = {
        relative-to = "top-right";
        x = 32;
        y = 32;
      };
    }
  ];

  # Auto-float these application dialogs
  autoFloatApps = [
    "dialog"
    "file_progress"
    "confirm"
    "download"
    "error"
    "notification"
  ];

  floatingRules =
    map (appId: {
      match._props.app-id = "^(${appId})";
      open-floating = true;
    })
    autoFloatApps;

  allWindowRules = [defaultWindowStyle] ++ conditionRules ++ floatingRules;

  layerRules = [
    {
      match._props.namespace = "^noctalia-backdrop";
      place-within-backdrop = true;
    }
  ];
in
  mkIf cfg.enable {
    wayland.windowManager.niri.settings = {
      _children =
        (map (rule: {window-rule = rule;}) allWindowRules)
        ++ (map (rule: {layer-rule = rule;}) layerRules);
    };
  }
