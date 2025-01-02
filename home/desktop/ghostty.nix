_: {
  programs.ghostty = {
    enable = true;
    settings = {
      window-decoration = false;
      gtk-single-instance = true;
      background-opacity = 0.8;
      confirm-close-surface = false;
      auto-update = "off";
      keybind = [
        "ctrl+t=new_tab"
        "ctrl+p=previous_tab"
        "ctrl+n=next_tab"
        "ctrl+w=close_surface"
        "ctrl+shift+r=reload_config"
        "ctrl+s>h=new_split:left"
        "ctrl+s>j=new_split:down"
        "ctrl+s>k=new_split:up"
        "ctrl+s>l=new_split:right"
      ];
    };
  };
}
