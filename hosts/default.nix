inputs: let
  system = "x86_64-linux";
  user = "jervw";
  hmModule = inputs.home-manager.nixosModules.home-manager;
  agenixModule = inputs.agenix.nixosModules.age;
  hyprlandModule = inputs.hyprland.homeManagerModules.default;
  wslModule = inputs.nixos-wsl.nixosModules.wsl;
  inherit (inputs.nixpkgs.lib) nixosSystem;
in {
  loki = nixosSystem {
    inherit system;
    specialArgs = {inherit user inputs;};
    modules = [
      ./loki
      hmModule
      agenixModule
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {inherit user inputs;};
          users.${user} = {
            imports = [
              ./loki/home.nix
              hyprlandModule
            ];
          };
        };
      }
    ];
  };

  thor = nixosSystem {
    inherit system;
    specialArgs = {inherit user inputs;};
    modules = [
      ./thor
      hmModule
      agenixModule
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {inherit user inputs;};
          users.${user} = {
            imports = [
              ./thor/home.nix
            ];
          };
        };
      }
    ];
  };

  vidar = nixosSystem {
    inherit system;
    specialArgs = {inherit user inputs;};
    modules = [
      ./vidar
      hmModule
      agenixModule
      wslModule
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {inherit user inputs;};
          users.${user} = {
            imports = [
              ./vidar/home.nix
            ];
          };
        };
      }
    ];
  };

  # Add more hosts here..
}
