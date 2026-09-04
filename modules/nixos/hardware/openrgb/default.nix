{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.hardware.openrgb;
in {
  options.${namespace}.hardware.openrgb.enable = lib.mkEnableOption "Enable OpenRGB";

  config = mkIf cfg.enable {
    services.hardware.openrgb = {
      enable = true;
      motherboard = "amd"; # TODO: Add option
    };
  };
}
