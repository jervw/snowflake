{
  pkgs,
  self,
  inputs,
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
  ];

  home.packages = with pkgs; [
    calibre
    bemoji
    beeper
    dconf
    nautilus
    ffmpeg
    libnotify
    imv
    obsidian
    obs-studio
    openjdk
    pavucontrol
    mission-center
    playerctl
    prismlauncher
    tomato-c
    vial
    networkmanagerapplet
    qbittorrent-enhanced
    xdg-utils
    nodejs
    inputs.zen-browser.packages."${system}".default
    self.packages.${system}.cider2
  ];
}
