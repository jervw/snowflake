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
    ./xdg.nix
    ./zed.nix
  ];

  home.packages = with pkgs; [
    dconf
    ffmpeg
    libnotify
    feh
    nautilus
    obs-studio
    openjdk
    pavucontrol
    playerctl
    prismlauncher
    seahorse
    tomato-c
    vesktop
    vial
    networkmanagerapplet
    qbittorrent-enhanced
    xdg-utils
    inputs.zen-browser.packages."${system}".default
    self.packages.${system}.cider2
  ];
}
