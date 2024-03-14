inputs: let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  system = "x86_64-linux";
  user = "jervw";

  homeModule = inputs.home-manager.nixosModules.home-manager;

  # Reusable home-manager configuration. WIP figure out better way
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit user inputs;};
    users.${user} = {
      _module.args.theme = import ../theme;
      imports = [
        ../home # For now it installs all packages under home/default.nix, figure out an better way
      ];
    };
  };
in {
  # Desktop
  loki = nixosSystem {
    inherit system;
    specialArgs = {inherit user inputs;};
    modules = [
      {networking.hostName = "loki";}
      {inherit home-manager;}
      homeModule
      ./loki
    ];
  };

  # HomeLab server
  thor = nixosSystem {
    inherit system;
    specialArgs = {inherit user inputs;};
    modules = [
      {networking.hostName = "thor";}
      {inherit home-manager;}
      homeModule
      ./thor
    ];
  };

  # Generic WSL host
  vidar = nixosSystem {
    inherit system;
    specialArgs = {inherit user inputs;};
    modules = [
      {networking.hostName = "vidar";}
      {inherit home-manager;}
      homeModule
      ./vidar
    ];
  };

  # # Hezner VPS
  # huginn = nixosSystem {
  #   inherit system;
  #   specialArgs = {inherit user inputs;};
  #   modules = [
  #     {networking.hostName = "huginn";}
  #     ./huginn
  #   ];
  # };

  # Add more hosts here..
}
