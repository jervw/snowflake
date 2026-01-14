{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.addons.clipman;
in {
  options.${namespace}.programs.addons.clipman = {
    enable = lib.mkEnableOption "Enable Clipman";
  };

  config = mkIf cfg.enable {
    services.clipman = {
      enable = true;
    };
  };
}
