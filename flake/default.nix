{inputs, ...}: {
  imports = [
    inputs.treefmt-nix.flakeModule
    ./images.nix
  ];
}
