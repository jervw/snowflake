{
  pkgs,
  self,
  inputs,
  ...
}: {
  imports = [
    ./firefox.nix
    ./foot.nix
    ./mpv.nix
    ./freetube.nix
    ./fuzzel.nix
    ./xdg.nix
    ./zathura.nix
  ];

  home.packages = with pkgs; [
    nautilus
    seahorse
    loupe
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
    # prismlauncher
    (prismlauncher.override {withWaylandGLFW = true;})
    openjdk22
    zed-editor
    inputs.zen-browser.packages."${system}".default
    self.packages.${pkgs.system}.cider2
  ];
}
