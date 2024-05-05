{inputs, ...}: {
  imports = [
    inputs.hyprland.homeManagerModules.default
    inputs.hyprlock.homeManagerModules.default

    ./hyprland
    ./ags.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./wlsunset.nix
  ];
}
