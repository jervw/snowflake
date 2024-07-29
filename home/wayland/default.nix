_: {
  imports = [
    ./hyprland
    ./hypridle.nix
    ./hyprlock.nix
    ./swaync.nix
    ./waybar.nix
    ./wlsunset.nix
    ./wpaperd.nix
  ];

  services = {
    swayosd.enable = true;
  };
}
