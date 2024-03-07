{inputs, ...}: {
  imports = [
    inputs.hyprland.homeManagerModules.default
    inputs.hyprlock.homeManagerModules.default
    inputs.hypridle.homeManagerModules.default

    ./hyprland
    ./hypridle.nix
    ./hyprlock.nix
    ./waybar.nix
    ./wlsunset.nix
  ];
}
