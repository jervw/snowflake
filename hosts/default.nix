{ nixpkgs, inputs, user, location, ... }:

let
  system = "x86_64-linux";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
in
{
  desktop = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit user location inputs system;
      host.hostName = "loki";
    };

    modules = [
      inputs.hyprland.nixosModules.default
      ./desktop
      ./configuration.nix

      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit user inputs;
          host.hostName = "loki";
        };

        home-manager.users.${user} = {
          imports = [
            ./home.nix
            ./desktop/home.nix
          ];
        };
      }
    ];
  };

  server = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit user location inputs system;
      host.hostName = "thor";
    };

    modules = [
      ./server
      ./configuration.nix

      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit user;
          host.hostName = "thor";
        };

        home-manager.users.${user} = {
          imports = [
            ./home.nix
            ./server/home.nix
          ];
        };
      }
    ];
  };

  # Add more hosts here..
}
