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
        apps = {
          thunar = mkDefault enabled;
          gpu-screen-recorder = mkDefault enabled;
        };
      };
      hardware = {
        audio = mkDefault enabled;
      };
      security = {
        keyring = mkDefault enabled;
      };
      system = {
        fonts = mkDefault enabled;
      };
    };

    services = {
      gvfs = mkDefault enabled;
      power-profiles-daemon = mkDefault enabled;
      upower = mkDefault enabled;
    };
  };
}
