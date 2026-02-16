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
    enable = lib.mkEnableOption "support for QMK";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [qmk via vial];

    hardware.keyboard.qmk.enable = true;

    services = {
      udev = {
        packages = [pkgs.via pkgs.vial];
      };
    };
  };
}
