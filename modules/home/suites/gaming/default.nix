{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkEnableOption types;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.suites.gaming;
in {
  options.${namespace}.suites.gaming = {
    enable = mkEnableOption "gaming applications ";
    enableEmulators = mkOpt types.bool true "Whether to enable emulators.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [
        # Launchers
        prismlauncher
        lutris
        heroic

        # Misc
        r2modman
        protontricks
        protonplus
        mangohud
      ]
      ++ lib.optionals cfg.enableEmulators [
        # Emulators
        rpcs3
        shadps4
        azahar
      ];
  };
}
