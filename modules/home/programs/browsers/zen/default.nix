{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.browsers.zen;
in {
  options.${namespace}.programs.browsers.zen = {
    enable = lib.mkEnableOption "Enable Zen-browser";
  };

  config = mkIf cfg.enable {
    programs.zen-browser = {
      enable = true;
    };
  };
}
