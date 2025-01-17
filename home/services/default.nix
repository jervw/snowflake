_: {
  imports = [
    ./hypridle.nix
    ./swaync.nix
    ./trayscale.nix
    ./syncthing.nix
    ./wlsunset.nix
  ];

  services = {
    swayosd.enable = true;
  };
}
