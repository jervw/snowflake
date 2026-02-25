{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.apps.zen;
in {
  options.${namespace}.programs.apps.zen = {
    enable = lib.mkEnableOption "Enable Zen-browser";
  };

  config = mkIf cfg.enable {
    programs.zen-browser = {
      enable = true;
    };
  };
}
