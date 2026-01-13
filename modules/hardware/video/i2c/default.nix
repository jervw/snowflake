{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.${namespace}.hardware.video.i2c;
in {
  options.${namespace}.hardware.video.i2c = {
    enable = lib.mkEnableOption "support for i2c monitor control";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.ddcutil];
    hardware.i2c.enable = true;
  };
}
