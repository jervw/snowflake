{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.${namespace}.programs.desktop.umbriel;
  uwsmCfg = config.${namespace}.programs.desktop.uwsm;
in {
  options.${namespace}.programs.desktop.umbriel = {
    enable = mkEnableOption "Umbriel compositor";
  };

  config = mkIf cfg.enable {
    # Installs the package, xdg-desktop-portal-umbriel and the graphics/polkit/dconf prerequisites.
    # It also registers a native (non-uwsm) "Umbriel" session, which cannot be disabled separately.
    programs.umbriel.enable = true;

    # Run under uwsm like niri. The bare binary is used instead of start-umbriel, which would
    # start its own umbriel.service. Under wayland-wm@umbriel.service Umbriel still publishes
    # its environment and reports readiness through the inherited NOTIFY_SOCKET.
    programs.uwsm.waylandCompositors.umbriel = mkIf uwsmCfg.enable {
      prettyName = "Umbriel";
      comment = "Umbriel compositor managed by UWSM";
      binPath = lib.getExe config.programs.umbriel.package;
    };
  };
}
