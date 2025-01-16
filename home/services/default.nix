_: {
  imports = [
    ./hypridle.nix
    ./swaync.nix
    ./wlsunset.nix
    ./syncthing.nix
  ];

  services = {
    swayosd.enable = true;
  };
}
