{...}: {
  programs.mpv = {
    enable = true;
    bindings = {
      "ALT+k" = "add sub-scale +0.1";
      "ALT+j" = "add sub-scale -0.1";
      "ALT+=" = "add video-zoom +0.1";
      "ALT+-" = "add video-zoom -0.1";
    };
    config = {
      gpu-context = "wayland";
      save-position-on-quit = true;
    };
  };
}
