{
  lib,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) enabled;
in {
  nietos = {
    user = enabled;

    services = {
      syncthing = enabled;
    };

    programs.tools = {
      claude-code = enabled;
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
