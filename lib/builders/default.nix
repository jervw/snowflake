{
  self,
  inputs,
  ...
}: {
  mkHost = import ./mkHost.nix {inherit self inputs;};
}
