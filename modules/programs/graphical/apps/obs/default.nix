{
  config,
  lib,
  pkgs,
  namespace,
  user,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.graphical.apps.obs;
in {
  options.${namespace}.programs.graphical.apps.obs = {
    enable = lib.mkEnableOption "Whether to enable OBS Studio.";
  };

  config = mkIf cfg.enable {
    hjem.users.${user}.rum.programs.obs-studio = {
      enable = true;
      package = pkgs.wrapOBS.override {inherit (pkgs) obs-studio;} {
        plugins = with pkgs.obs-studio-plugins; [
          obs-pipewire-audio-capture
          waveform
          obs-vkcapture
          obs-obs-websocket
          wlrobs
        ];
      };
    };
  };
}
