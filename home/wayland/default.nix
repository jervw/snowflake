{pkgs, ...}: {
  imports = [
    ./hyprland
    ./niri
    ./hyprlock.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    grimblast
    wl-clipboard
    wtype
    wlr-randr
    hyprpicker
    xorg.xeyes
    xorg.xrandr
    xclip
  ];
}
