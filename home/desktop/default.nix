{
  pkgs,
  self,
  ...
}: {
  imports = [
    ./firefox.nix
    ./foot.nix
    ./fuzzel.nix
    ./xdg.nix
  ];

  home.packages = with pkgs; [
    nautilus
    loupe
    playerctl
    pavucontrol
    vesktop
    obs-studio
    vial
    lutris
    ffmpeg
    libnotify
    tomato-c
    mpd
    plex-desktop
    zed-editor
    self.packages.${pkgs.system}.cider2
  ];
}
