{
  config,
  lib,
  pkgs,
  namespace,
  user,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.graphical.apps.mpv;
in {
  options.${namespace}.programs.graphical.apps.mpv = {
    enable = lib.mkEnableOption "Whether to enable mpv.";
  };

  config = mkIf cfg.enable {
    hjem.users.${user}.rum.programs.mpv = {
      enable = true;
      profiles = {
        big-cache = {
          cache = true;
          demuxer-max-bytes = "512Mib";
          demuxer-readhead-secs = 20;
        };
        reduce-judder = {
          interpolation = true;
          video-sync = "display-resample";
        };
      };
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
        sponsorblock
        mpris # media key control
        uosc # UI
        acompressor # FFMPEG audio compress
        thumbfast # thumbnails when seeking
      ];
    };
  };
}
