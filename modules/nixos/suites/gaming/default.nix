{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault mkEnableOption mkIf;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.suites.gaming;
in {
  options.${namespace}.suites.gaming = {
    enable = mkEnableOption "Gaming configuration";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # Launchers
      lutris
      heroic
      bottles
      cartridges

      # Emulators
      rpcs3
      shadps4

      # Misc
      r2modman
      mangohud
    ];

    snowflake = {
      programs = {
        steam = mkDefault enabled;
        gamemode = mkDefault enabled;
        gamescope = mkDefault enabled;
      };
    };
  };
}
