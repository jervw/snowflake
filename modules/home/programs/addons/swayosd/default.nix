{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.addons.swayosd;
in {
  options.${namespace}.programs.addons.swayosd = {
    enable = lib.mkEnableOption "Enable swayosd";
  };

  config = mkIf cfg.enable {
    services.swayosd = {
      enable = true;
    };
  };
}
