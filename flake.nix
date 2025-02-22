{
  description = "jervw's NixOS configurations";

  inputs = {
    impermanence.url = "github:nix-community/impermanence";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    stylix.url = "github:danth/stylix";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.darwin.follows = "";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:philtaken/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ssh-keys = {
      url = "https://github.com/jervw.keys";
      flake = false;
    };

    zen-browser = {
      # url = "github:omarcresp/zen-browser-flake";
      url = "github:leonhazen/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];

      imports = [
        ./flake
        ./hosts
        ./lib
        ./pkgs
      ];

      perSystem = {
        pkgs,
        config,
        ...
      }: {
        devShells.default = pkgs.mkShell {
          packages = [pkgs.alejandra pkgs.deploy-rs];
        };

        treefmt = {
          projectRootFile = "flake.nix";
          programs = {
            alejandra.enable = true;
            statix.enable = true;
            deadnix.enable = true;
          };
        };

        formatter = config.treefmt.build.wrapper;
      };
    };
}
