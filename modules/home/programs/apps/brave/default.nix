{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.apps.brave;
in {
  options.${namespace}.programs.apps.brave = {
    enable = lib.mkEnableOption "Enable brave browser";
  };

  config = mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.brave-origin;
    };
  };
}
