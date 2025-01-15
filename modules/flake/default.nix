{inputs, ...}: {
  imports = [
    inputs.treefmt-nix.flakeModule
    ./deploy.nix
  ];
}
