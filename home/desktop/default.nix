{
  pkgs,
  self,
  inputs,
  ...
}: {
  imports = [
    ./firefox.nix
    ./foot.nix
    ./freetube.nix
    ./fuzzel.nix
    ./xdg.nix
  ];

  home.packages = with pkgs; [
    nautilus
    loupe
    celluloid
    freetube
    playerctl
    pavucontrol
    vesktop
    obs-studio
    vial
    ffmpeg
    libnotify
    tomato-c
    mpd
    steam-run
    plex-desktop
    prismlauncher
    openjdk22
    zed-editor
    inputs.zen-browser.packages."${system}".default
    self.packages.${pkgs.system}.cider2
  ];
}
