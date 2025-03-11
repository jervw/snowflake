{
  pkgs,
  self,
  inputs,
  ...
}: {
  imports = [
    ./freetube.nix
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
    vesktop
    vial
    networkmanagerapplet
    qbittorrent-enhanced
    xdg-utils
    nodejs
    inputs.zen-browser.packages."${system}".default
    self.packages.${system}.cider2
    self.packages.${system}.beeper-beta
  ];
}
