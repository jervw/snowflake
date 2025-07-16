{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkDefault mkEnableOption mkIf;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.suites.desktop;
in {
  options.${namespace}.suites.desktop = {
    enable = mkEnableOption "Desktop configuration";
  };

  config = mkIf cfg.enable {
    snowflake = {
      programs = {
        hardware = {
          audio = mkDefault enabled;
        };

        security = {
          keyring = mkDefault enabled;
        };
      };
    };
  };
}
