{
  description = "My personal NixOS system configuration.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:vaxerski/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, hyprland, home-manager, ... }:
    let
      user = "jervw";
      location = "$HOME/.";
    in
    {
      nixosConfigurations = (
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit nixpkgs home-manager hyprland user location;
        }
      );

      homeConfigurations."work" = home-manager.lib.homeManagerConfiguration (
        import ./work {
          inherit nixpkgs;          
        }
      );
    };
}
