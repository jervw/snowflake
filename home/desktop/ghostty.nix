_: {
  programs.ghostty = {
    enable = true;
    settings = {
      window-decoration = false;
      background-opacity = 0.8;
      confirm-close-surface = false;
      auto-update = "off";

      # Both improve startup time
      gtk-single-instance = true;
      gtk-adwaita = false;

      keybind = [
        # Tabs
        "ctrl+t=new_tab"
        "ctrl+shift+h=previous_tab"
        "ctrl+shift+l=next_tab"

        # Split -- New
        "ctrl+s>h=new_split:left"
        "ctrl+s>j=new_split:down"
        "ctrl+s>k=new_split:up"
        "ctrl+s>l=new_split:right"

        # Split -- Move
        "alt+h=goto_split:left"
        "alt+j=goto_split:bottom"
        "alt+k=goto_split:top"
        "alt+l=goto_split:right"

        # Split -- Resize
        "alt+ctrl+h=resize_split:left,20"
        "alt+ctrl+j=resize_split:down,20"
        "alt+ctrl+k=resize_split:up,20"
        "alt+ctrl+l=resize_split:right,20"

        # Misc
        "alt+q=close_surface"
        "ctrl+shift+r=reload_config"
      ];
    };
  };
}
