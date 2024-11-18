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
    ./zed.nix
  ];

  home.packages = with pkgs; [
    ffmpeg
    fractal
    protonmail-desktop
    libnotify
    feh
    mpd
    nautilus
    obs-studio
    openjdk
    pavucontrol
    playerctl
    brillo
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
