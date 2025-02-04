{
  pkgs,
  self,
  inputs,
  ...
}: {
  imports = [
    ./fuzzel.nix
    ./ghostty.nix
    ./mpv.nix
    ./stylix.nix
    ./zathura.nix
    ./xdg.nix
    ./zed.nix
  ];

  home.packages = with pkgs; [
    bemoji
    ciano
    dconf
    ffmpeg
    libnotify
    imv
    xfce.thunar
    xfce.thunar-archive-plugin
    obsidian
    obs-studio
    openjdk
    pavucontrol
    playerctl
    prismlauncher
    tomato-c
    vesktop
    vial
    networkmanagerapplet
    qbittorrent-enhanced
    xdg-utils
    nodejs
    inputs.zen-browser.packages."${system}".default
    self.packages.${system}.cider2
  ];
}
