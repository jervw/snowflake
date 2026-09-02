{
  lib,
  namespace,
  config,
  ...
}: let
  cfg = config.${namespace}.programs.desktop.niri;
in {
  options.${namespace}.programs.desktop.niri = {
    enable = lib.mkEnableOption "Enable niri";
  };

  imports = lib.snowfall.fs.get-non-default-nix-files ./.;

  config = lib.mkIf cfg.enable {
    wayland.windowManager.niri = {
      enable = true;
      systemd.enable = false;
    };
  };
}
