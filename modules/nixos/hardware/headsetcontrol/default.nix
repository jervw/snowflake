{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.hardware.headsetcontrol;
in {
  options.${namespace}.hardware.headsetcontrol = {
    enable = lib.mkEnableOption "support for HeadsetControl";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.headsetcontrol];

    services.udev.packages = [pkgs.headsetcontrol];
  };
}
