{
  self,
  inputs,
  ...
}: let
  extraSpecialArgs = {inherit inputs self;};

  homeImports = {
    loki = [
      ../.
      ./loki
    ];
    thor = [
      ../.
      ./thor
    ];
  };

  inherit (inputs.home-manager.lib) homeManagerConfiguration;
  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
in {
  _module.args = {inherit homeImports;};

  flake = {
    homeConfigurations = {
      loki = homeManagerConfiguration {
        modules = homeImports.loki;
        inherit pkgs extraSpecialArgs;
      };

      thor = homeManagerConfiguration {
        modules = homeImports.thor;
        inherit pkgs extraSpecialArgs;
      };
    };
  };
}
