inputs: let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  system = "x86_64-linux";
  user = "jervw";

  lanzaboote = inputs.lanzaboote.nixosModules.lanzaboote;
  hm = inputs.home-manager.nixosModules.home-manager;
  wsl = inputs.nixos-wsl.nixosModules.wsl;
  disko = inputs.disko.nixosModules.disko;
  hyprland = inputs.hyprland.homeManagerModules.default;
  hyprlock = inputs.hyprlock.homeManagerModules.default;
  hypridle = inputs.hypridle.homeManagerModules.default;
in {
  # Desktop
  loki = nixosSystem {
    inherit system;
    specialArgs = {inherit user inputs;};
    modules = [
      ./loki
      hm
      lanzaboote
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {inherit user inputs;};
          users.${user} = {
            _module.args.theme = import ../theme;
            imports = [
              ./loki/home.nix
              hyprland
              hyprlock
              hypridle
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
      hm
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
      hm
      wsl
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
      disko
    ];
  };

  # Add more hosts here..
}
