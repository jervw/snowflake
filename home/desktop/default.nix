{pkgs, ...}: {
  imports = [
    # ../theme/dracula.nix
    ./firefox.nix
    ./foot.nix
    ./fuzzel.nix
    ./mpv.nix
    ./xdg.nix
    ./zathura.nix
  ];

  home.packages = with pkgs; [
    gnome.nautilus
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
    tomato-c
    gh
    plex-mpv-shim
    (callPackage ../../pkgs/cider2 {})
  ];
}
