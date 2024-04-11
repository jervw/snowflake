{pkgs, ...}: {
  imports = [
    # ../theme/dracula.nix
    ./firefox.nix
    ./foot.nix
    ./mpv.nix
    ./xdg.nix
    ./zathura.nix
  ];

  home.packages = with pkgs; [
    gnome.seahorse
    xfce.thunar
    loupe
    networkmanagerapplet
    feh
    vscode-fhs
    playerctl
    pavucontrol
    vesktop
    obs-studio
    signal-desktop
    vial
    steam
    ffmpeg
    ffmpegthumbnailer
    poppler
    libnotify
    (callPackage ../../pkgs/cider2 {})
  ];
}
