{pkgs, ...}: {
  programs.mpv = {
    enable = true;
    bindings = {
      "ALT+k" = "add sub-scale +0.1";
      "ALT+j" = "add sub-scale -0.1";
      "ALT+=" = "add video-zoom +0.1";
      "ALT+-" = "add video-zoom -0.1";
    };
    scripts = with pkgs.mpvScripts; [
      uosc # UI
      acompressor # ffmpeg audio compress
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
}
