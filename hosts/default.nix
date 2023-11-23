inputs:

let
  system = "x86_64-linux";
  user = "jervw";
  hmModule = inputs.home-manager.nixosModules.home-manager;
  hyprlandModule = inputs.hyprland.homeManagerModules.default;
  inherit (inputs.nixpkgs.lib) nixosSystem;
in
{
  loki = nixosSystem {
    inherit system;
    specialArgs = {inherit user inputs;};
    modules = [
      ./loki
      hmModule
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

  # Add more hosts here..
}
