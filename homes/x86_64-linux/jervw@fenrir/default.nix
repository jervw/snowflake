{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) enabled;
in {
  snowflake = {
    user = {
      enable = true;
      inherit (config.snowfallorg.user) name;
    };

    services = {
      syncthing = enabled;
    };

    system = {
      xdg = enabled;
    };

    suites = {
      core = enabled;
      desktop = enabled;
    };
  };

  # Work around to fix issue with cursor scaling on HIDPI
  home.pointerCursor.gtk.enable = lib.mkForce false;
}
