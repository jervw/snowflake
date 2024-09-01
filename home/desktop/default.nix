{
  pkgs,
  self,
  inputs,
  ...
}: {
  imports = [
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
    playerctl
    pavucontrol
    vesktop
    obs-studio
    vial
    ffmpeg
    libnotify
    tomato-c
    mpd
    openjdk22
    zed-editor
    (prismlauncher.override {withWaylandGLFW = true;})
    inputs.zen-browser.packages."${system}".default
    self.packages.${pkgs.system}.cider2
  ];
}
