{inputs, ...}: {
  imports = [
    inputs.hyprland.homeManagerModules.default

    ./hyprland
    ./ags.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./wlsunset.nix
  ];
}
