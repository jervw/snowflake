{pkgs, ...}: {
  imports = [
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
    obsidian
    signal-desktop
    vial
    steam
    ffmpeg
    libnotify
    tomato-c
    mpd
    chatterino2
    (callPackage ../../pkgs/cider2 {})
  ];
}
