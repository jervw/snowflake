_: {
  imports = [
    ./hypridle.nix
    ./swaync.nix
    ./wlsunset.nix
  ];

  services = {
    swayosd.enable = true;
  };
}
