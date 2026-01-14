{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.${namespace}.programs.wm.niri;
in {
  options.${namespace}.programs.wm.niri = {
    enable = lib.mkEnableOption "Enable Niri";
  };

  config = {
    programs.niri = {
      inherit (cfg) enable;
      package = pkgs.niri-unstable;
    };

    ${namespace}.programs.display-managers.greetd.sessions = mkIf cfg.enable [
      "niri-session &> /dev/null"
    ];
  };
}
