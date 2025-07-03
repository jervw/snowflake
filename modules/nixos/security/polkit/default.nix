{
  config,
  lib,
  namespace,
  ...
}: let
  cfg = config.${namespace}.security.polkit;
in {
  options.${namespace}.security.polkit = {
    enable = lib.mkEnableOption "enable default polkit package";
  };

  # TODO Switch to KDE polkit agent on Hyprland
  config = lib.mkIf cfg.enable {
    security.polkit = {
      enable = true;
    };
  };
}
