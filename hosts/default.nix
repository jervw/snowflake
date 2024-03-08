inputs: let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  system = "x86_64-linux";
  user = "jervw";

  lanzaboote = inputs.lanzaboote.nixosModules.lanzaboote;
  home = inputs.home-manager.nixosModules.home-manager;
  wsl = inputs.nixos-wsl.nixosModules.wsl;
  disko = inputs.disko.nixosModules.disko;

  # Reusable home-manager configuration. WIP figure out better way
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit user inputs;};
    users.${user} = {
      _module.args.theme = import ../theme;
      imports = [
        ../home # For now it installs all packages under home, figure out better way
      ];
    };
  };
in {
  # Desktop
  loki = nixosSystem {
    inherit system;
    specialArgs = {inherit user inputs;};
    modules = [
      ./loki
      home
      disko
      lanzaboote
      {inherit home-manager;}
    ];
  };

  # HomeLab server
  thor = nixosSystem {
    inherit system;
    specialArgs = {inherit user inputs;};
    modules = [
      ./thor
      home
      {inherit home-manager;}
    ];
  };

  # Generic WSL host
  vidar = nixosSystem {
    inherit system;
    specialArgs = {inherit user inputs;};
    modules = [
      ./vidar
      home
      wsl
      {inherit home-manager;}
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
