{inputs, ...}: {
  imports = [
    inputs.tailray.homeManagerModules.default
    ./tailray.nix
    # ./syncthing.nix TODO, declarative config to be merged to home-manager #5616
  ];
}
