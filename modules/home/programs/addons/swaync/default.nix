{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.addons.swaync;
in {
  options.${namespace}.programs.addons.swaync = {
    enable = lib.mkEnableOption "Enable swaync";
  };

  config = mkIf cfg.enable {
    services.swaync = {
      enable = true;
      settings = {
        positionX = "right";
        positionY = "right";
        layer = "overlay";
        control-center-layer = "overlay";
        layer-shell = true;
        control-center-positionX = "right";
        control-center-positionY = "top";
        control-center-margin-top = 5;
        control-center-margin-bottom = 0;
        control-center-margin-right = 0;
        control-center-margin-left = 0;
        notification-2fa-action = true;
        notification-inline-replies = false;
        notification-icon-size = 48;
        notification-body-image-height = 100;
        notification-body-image-width = 200;
        timeout = 5;
        timeout-low = 10;
        timeout-critical = 20;
        fit-to-screen = false;
        control-center-width = 400;
        control-center-height = 650;
        notification-window-width = 400;
        keyboard-shortcuts = true;
        image-visibility = "when-available";
        transition-time = 200;
        hide-on-clear = true;
        hide-on-action = true;
        script-fail-notify = true;
        widgets = [
          "inhibitors"
          "title"
          "notifications"
          "mpris"
        ];
        widget-config = {
          inhibitors = {
            text = "Inhibitors";
            button-text = "Clear All";
            clear-all-button = true;
          };
          title = {
            text = "Notifications";
            clear-all-button = false;
          };
          mpris = {
            image-size = 64;
            image-radius = 50;
          };
        };
      };
    };
  };
}
