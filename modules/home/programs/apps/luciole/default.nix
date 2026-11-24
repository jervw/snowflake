{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.apps.luciole;
in {
  options.${namespace}.programs.apps.luciole = {
    enable = lib.mkEnableOption "Enable Luciole";
  };

  config = mkIf cfg.enable {
    programs.luciole.enable = true;

    xdg.portal = {
      extraPortals = [config.programs.luciole.package];
      # gtk is only used when the luciole backend is absent, not when it fails.
      config.common."org.freedesktop.impl.portal.FileChooser" = ["luciole" "gtk"];
    };

    # The package ships its FileManager1 service under a Luciole-specific name;
    # a user-level copy under the generic name makes the bus prefer it
    # ("Show in folder" from browsers, portals, etc.).
    xdg.dataFile."dbus-1/services/org.freedesktop.FileManager1.service".source = "${config.programs.luciole.package}/share/dbus-1/services/dev.noctalia.luciole.FileManager1.service";
  };
}
