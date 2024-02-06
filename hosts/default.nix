inputs: let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  system = "x86_64-linux";
  user = "jervw";

  secureMod = inputs.lanzaboote.nixosModules.lanzaboote;
  homeMod = inputs.home-manager.nixosModules.home-manager;
  wslMod = inputs.nixos-wsl.nixosModules.wsl;
  diskoMod = inputs.disko.nixosModules.disko;
  agenixMod = inputs.agenix.nixosModules.age;
  hyprlandMod = inputs.hyprland.homeManagerModules.default;
in {
  # Desktop
  loki = nixosSystem {
    inherit system;
    specialArgs = {inherit user inputs;};
    modules = [
      ./loki
      secureMod
      homeMod
      agenixMod
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {inherit user inputs;};
          users.${user} = {
            imports = [
              ./loki/home.nix
              hyprlandMod
            ];
          };
        };
      }
    ];
  };

  # Home server
  thor = nixosSystem {
    inherit system;
    specialArgs = {inherit user inputs;};
    modules = [
      ./thor
      homeMod
      agenixMod
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

  # Generic WSL host
  vidar = nixosSystem {
    inherit system;
    specialArgs = {inherit user inputs;};
    modules = [
      ./vidar
      homeMod
      agenixMod
      wslMod
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

  # Hezner VPS
  huginn = nixosSystem {
    inherit system;
    specialArgs = {inherit user inputs;};
    modules = [
      ./huginn
      diskoMod
    ];
  };

  # Add more hosts here..
}
