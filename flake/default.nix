{inputs, ...}: {
  imports = [
    inputs.treefmt-nix.flakeModule
    ./formatter.nix
  ];
}
