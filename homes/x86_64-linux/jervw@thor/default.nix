{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) enabled;
in {
  nietos = {
    user = {
      enable = true;
      inherit (config.snowfallorg.user) name;
    };

    services = {
      syncthing = {
        enable = true;
        versioning = true;
      };
    };

    programs.tools = {
      claude-code = enabled;
      # Headless, so no ZenNotes desktop app to talk to.
      mcp.zennotes = false;
    };

    system = {
      xdg = enabled;
    };

    suites = {
      core = enabled;
    };
  };
}
