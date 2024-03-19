{
  self,
  inputs,
  homeImports,
  ...
}: {
  flake.nixosConfigurations = let
    inherit (inputs.nixpkgs.lib) nixosSystem;
    specialArgs = {inherit user inputs self;};
    user = "jervw";
  in {
    # Desktop
    loki = nixosSystem {
      inherit specialArgs;
      modules = [
        ./loki
        {networking.hostName = "loki";}

        {
          home-manager = {
            users.${user}.imports = homeImports.loki;
            extraSpecialArgs = specialArgs;
          };
        }
      ];
    };

    # HomeLab server
    thor = nixosSystem {
      inherit specialArgs;
      modules = [
        ./thor
        {networking.hostName = "thor";}

        {
          home-manager = {
            users.${user}.imports = homeImports.thor;
            extraSpecialArgs = specialArgs;
          };
        }
      ];
    };

    # Add more hosts here..
  };
}
