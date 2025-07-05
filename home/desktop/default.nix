{
  pkgs,
  self,
  ...
}: {
  imports = [
    ./foot.nix
    ./freetube.nix
    ./fuzzel.nix
    ./ghostty.nix
    ./mpv.nix
    ./stylix.nix
    ./vesktop.nix
    ./zathura.nix
    ./xdg.nix
    ./zed.nix
    ./zen-browser.nix
  ];

  home.packages = with pkgs; [
    anki-bin
    calibre
    bemoji
    beeper
    dconf
    kdePackages.dolphin
    ffmpeg
    libnotify
    imv
    obsidian
    obs-studio
    openjdk
    pavucontrol
    normcap
    mission-center
    playerctl
    prismlauncher
    tomato-c
    vial
    networkmanagerapplet
    qbittorrent-enhanced
    xdg-utils
    nodejs
    self.packages.${system}.cider
  ];
}
