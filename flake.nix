{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:vaxerski/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... } @ inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        sops
        alejandra
        yaml-language-server
      ];
    };

      formatter.${system} = pkgs.alejandra;
      nixosConfigurations = import ./hosts inputs;
    };
}
