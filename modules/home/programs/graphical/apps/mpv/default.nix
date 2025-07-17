{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.graphical.apps.mpv;
in {
  options.${namespace}.programs.graphical.apps.mpv = {
    enable = lib.mkEnableOption "Enable mpv";
  };

  config = mkIf cfg.enable {
    programs.mpv = {
      enable = true;
      defaultProfiles = ["gpu-hq"];
      bindings = {
        "ALT+k" = "add sub-scale +0.1";
        "ALT+j" = "add sub-scale -0.1";
        "ALT+h" = "add sub-delay +0.05";
        "ALT+l" = "add sub-delay -0.05";
        "ALT+=" = "add video-zoom +0.1";
        "ALT+-" = "add video-zoom -0.1";
        "WHEEL_RIGHT" = "add sub-scale -0.01";
        "WHEEL_LEFT" = "add sub-scale +0.01";
      };

      scripts = with pkgs.mpvScripts; [
        mpv-cheatsheet # help
        mpris # media key control
        uosc # UI
        acompressor # FFMPEG audio compress
        thumbfast # thumbnails when seeking
      ];
    };

    services.plex-mpv-shim = {
      enable = true;
      settings = {
        mpv_ext = true;
        mpv_ext_no_ovr = true;
        fullscreen = false;
      };
    };
  };
}
