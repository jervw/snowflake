{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.graphical.apps.obs;
in {
  options.${namespace}.programs.graphical.apps.obs = {
    enable = lib.mkEnableOption "Enable OBS";
  };

  config = mkIf cfg.enable {
    programs.obs = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-pipewire-audio-capture
        obs-vkcapture
        wlrobs
      ];
    };
  };
}
