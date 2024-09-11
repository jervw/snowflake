{
  pkgs,
  self,
  inputs,
  ...
}: {
  imports = [
    ./anyrun.nix
    ./foot.nix
    ./mpv.nix
    ./freetube.nix
    ./xdg.nix
    ./zathura.nix
  ];

  home.packages = with pkgs; [
    calibre
    ffmpeg
    fractal
    libnotify
    loupe
    mpd
    nautilus
    obs-studio
    openjdk22
    pavucontrol
    playerctl
    prismlauncher
    seahorse
    tomato-c
    vesktop
    vial
    zed-editor
    inputs.zen-browser.packages."${system}".default
    self.packages.${pkgs.system}.cider2
  ];
}
