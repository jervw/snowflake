{ pkgs, hyprland, ... }:
with hyprland;
let 
  bar_config = import ./config.nix { inherit hyprland; };
  bar_style = import ./style.nix { inherit hyprland; };
in
{
  programs.waybar = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.waybar-hyprland;
    settings = bar_config;
    style = bar_style;
  };
}
