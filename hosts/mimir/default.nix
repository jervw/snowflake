{
  lib,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) enabled;
in {
  imports = [./hardware.nix];

  snowflake = {
    programs.terminal.tools.direnv = enabled;
    suites = {
      core = enabled;
    };

    system.boot = enabled;
  };

  system.stateVersion = "24.05";
}
