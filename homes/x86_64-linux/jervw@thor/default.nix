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
    };
  };
}
