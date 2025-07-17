{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.hardware.qmk;
in {
  options.${namespace}.hardware.qmk = {
    enable = lib.mkEnableOption "support for QMK (Vial)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.vial];
    services = {
      udev = {
        packages = [pkgs.vial];
      };
    };
  };
}
