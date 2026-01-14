{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.${namespace}.programs.wm.hyprland;
in {
  options.${namespace}.programs.wm.hyprland = {
    enable = lib.mkEnableOption "Enable Hyprland";
  };

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };

    ${namespace}.programs.display-managers.greetd.sessions = [
      "start-hyprland &> /dev/null"
    ];
  };
}
