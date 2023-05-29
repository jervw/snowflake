{ pkgs, hyprland, ... }:

 {
programs.waybar = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.waybar-hyprland;
    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 0;
      mod = "dock";
      exclusive = true;
      passtrough = false;
      modules-left = [ "wlr/workspaces" ];
      modules-center = [ "hyprland/window"];
      modules-right = [ "tray" "pulseaudio" "clock" ];
      "wlr/workspaces" = {
         format = "{icon}";
         on-click = "activate";
         all-outputs = true;
         format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            "urgent" = "";
            "active" = "";
            "default" = "";
         };
       };
       "tray" = {
         icon-size = 16;
         tooltip = false;
         spacing = 15;
       };
       "clock" = {
         format = "{: %R   %d/%m}";
         tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
       };
       "pulseaudio" = {
        format = "{icon} {volume}%";
        tooltip = false;
        format-muted = " Muted";
        on-click = "pamixer -t";
        on-scroll-up = "pamixer -i 5";
        on-scroll-down = "pamixer -d 5";
        scroll-step = 5;
        format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
        };
       };
    };
    style = builtins.readFile ./waybar.css;
  };
}
