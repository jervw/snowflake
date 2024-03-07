{pkgs, ...}: {
  imports = [
    ../theme/dracula.nix
    ./alacritty.nix
    ./dunst.nix
    ./firefox.nix
    ./foot.nix
    ./mpv.nix
    ./rofi.nix
    ./xdg.nix
    ./zathura.nix
  ];

  home.packages = with pkgs; [
    gnome.file-roller
    gnome.nautilus
    loupe
    networkmanagerapplet
    feh
    vscode-fhs
    playerctl
    pavucontrol
    qbittorrent
    vesktop
    obs-studio
    vial
    lutris
    heroic
    steam
    (callPackage ../../pkgs/cider2 {})
  ];
}
