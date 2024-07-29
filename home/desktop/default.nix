{
  pkgs,
  self,
  ...
}: {
  imports = [
    ./firefox.nix
    ./foot.nix
    ./fuzzel.nix
    ./mpv.nix
    ./xdg.nix
    ./zathura.nix
  ];

  home.packages = with pkgs; [
    nautilus
    loupe
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
    lutris
    ffmpeg
    libnotify
    tomato-c
    mpd
    chatterino2
    plex-desktop
    self.packages.${pkgs.system}.cider2
  ];
}
