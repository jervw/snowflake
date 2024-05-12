{inputs, ...}: {
  imports = [
    inputs.hyprlock.homeManagerModules.default

    ./hyprland
    ./hypridle.nix
    ./hyprlock.nix
    ./waybar.nix
    ./wlsunset.nix
  ];

  services = {
    swaync.enable = true;
    swayosd.enable = true;
  };
}
