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
    dconf
    ffmpeg
    libnotify
    feh
    nautilus
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
    inputs.zen-browser.packages."${system}".default
    self.packages.${system}.cider2
  ];
}
