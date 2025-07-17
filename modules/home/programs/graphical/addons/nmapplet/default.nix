{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.graphical.addons.nmapplet;
in {
  options.${namespace}.programs.graphical.addons.nmapplet = {
    enable = lib.mkEnableOption "Enable network-manager-applet";
  };

  config = mkIf cfg.enable {
    services.network-manager-applet = {
      enable = true;
    };
  };
}
