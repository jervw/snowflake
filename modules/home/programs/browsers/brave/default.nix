{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.browsers.brave;
in {
  options.${namespace}.programs.browsers.brave = {
    enable = lib.mkEnableOption "Enable Brave browser";
  };

  config = mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.brave;
    };
  };
}
