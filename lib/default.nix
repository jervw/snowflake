{
  self,
  inputs,
  ...
}: {
  flake.lib = let
    inherit (inputs.nixpkgs) lib;

    moduleLib = import ./module {inherit lib;};
    builders = import ./builders {inherit self inputs;};
  in {
    snowflake = moduleLib;
    inherit (builders) mkHost;
  };
}
