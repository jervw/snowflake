{ lib, nixpkgs, home-manager, hyprland, user, location, ... }:

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
      inherit user location hyprland system;
      host.hostName = "loki";
    };

    modules = [
      hyprland.nixosModules.default
      ./desktop
      ./configuration.nix

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit user;
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

  # Add more hosts here..
}
