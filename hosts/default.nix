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
        {networking.hostName = "loki";}
        ./loki

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
        {networking.hostName = "thor";}
        ./thor

        {
          home-manager = {
            users.${user}.imports = homeImports.thor;
            extraSpecialArgs = specialArgs;
          };
        }
      ];
    };

    # Generic WSL
    vidar = nixosSystem {
      inherit specialArgs;
      modules = [
        {networking.hostName = "vidar";}
        ./vidar

        {
          home-manager = {
            users.${user}.imports = homeImports.vidar;
            extraSpecialArgs = specialArgs;
          };
        }
      ];
    };

    # Hezner VPS
    huginn = nixosSystem {
      inherit specialArgs;
      modules = [
        {networking.hostName = "huginn";}
        ./huginn
      ];
    };

    # Add more hosts here..
  };
}
