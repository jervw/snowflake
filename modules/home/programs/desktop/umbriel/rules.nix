{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.${namespace}.programs.desktop.umbriel;

  # App IDs (regex) of windows that get a blurred background.
  blurApps = [
    "dev\\.zellij\\.Zellij"
    # Umbriel lacks ext-background-effect-v1, so foot's own blur request is ignored
    "foot(client)?"
  ];

  screencastColor = {
    active = "#f38ba8ff";
    inactive = "#7d0d2dff";
  };

  conditionRules = [
    {
      match.is_cast_target = true;
      border_color_focused = screencastColor.active;
      border_color_unfocused = screencastColor.inactive;
    }

    {
      match.title = "^Picture in picture$";
      default_floating = true;
      default_position = {
        anchor = "top_right";
        x = 32;
        y = 32;
      };
    }
  ];

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
      match.app_id = "^(${appId})";
      default_floating = true;
    })
    autoFloatApps;

  blurRules =
    map (appId: {
      match.app_id = "^(${appId})$";
      blur = true;
    })
    blurApps;
in
  mkIf cfg.enable {
    programs.umbriel.settings = {
      appearance.corner_radius = 16;
      window_rule = conditionRules ++ floatingRules ++ blurRules;
    };
  }
