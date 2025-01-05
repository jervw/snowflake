{
  pkgs,
  self,
  inputs,
  ...
}: {
  imports = [
    ./anyrun.nix
    ./ghostty.nix
    ./mpv.nix
    ./xdg.nix
    ./zed.nix
  ];

  home.packages = with pkgs; [
    ffmpeg
    fractal
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
    inputs.zen-browser.packages."${system}".default
    self.packages.${pkgs.system}.cider2
  ];
}
