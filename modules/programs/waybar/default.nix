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
      modules-right = [ "tray" "clock" ];
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
    };
    style = builtins.readFile ./waybar.css;
  };
}
