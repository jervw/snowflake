{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.${namespace}.programs.graphical.wm.niri;
in {
  options.${namespace}.programs.graphical.wm.niri = {
    enable = lib.mkEnableOption "Enable Niri";
  };

  config = {
    programs.niri = {
      enable = cfg.enable;
      package = pkgs.niri;
    };

    ${namespace}.programs.graphical.display-managers.greetd.sessions = mkIf cfg.enable [
      "niri-session &> /dev/null"
    ];
  };
}
