{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.graphical.browsers.zen;
in {
  options.${namespace}.programs.graphical.browsers.zen = {
    enable = lib.mkEnableOption "Enable Zen-browser";
  };

  config = mkIf cfg.enable {
    programs.zen-browser = {
      enable = true;
      nativeMessagingHosts = [pkgs.firefoxpwa];
    };
  };
}
