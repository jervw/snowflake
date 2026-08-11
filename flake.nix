{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    impermanence.url = "github:nix-community/impermanence";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    nixcord.url = "github:FlameFlag/nixcord";
    helix.url = "github:gj1118/helix";
    ghostty.url = "github:ghostty-org/ghostty";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.darwin.follows = "";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snowfall-lib = {
      url = "github:anntnzrb/snowfall-lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ssh-keys = {
      url = "https://github.com/jervw.keys";
      flake = false;
    };
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;

      src = ./.;

      snowfall = {
        namespace = "snowflake";
        meta = {
          name = "snowflake";
          title = "Snowflake";
        };
      };

      channels-config = {
        allowUnfree = true;
        permittedInsecurePackages = ["electron-40.10.5" "pnpm-9.15.9"];
      };

      systems.modules.nixos = with inputs; [
        agenix.nixosModules.default
        impermanence.nixosModule
        lanzaboote.nixosModules.lanzaboote
        nix-index.nixosModules.nix-index
      ];

      homes.modules = with inputs; [
        agenix.homeManagerModules.default
        noctalia.homeModules.default
        nixcord.homeModules.nixcord
      ];

      # Other generic outputs
      outputs-builder = channels: {
        formatter = inputs.treefmt-nix.lib.mkWrapper channels.nixpkgs {
          projectRootFile = "flake.nix";
          programs = {
            alejandra.enable = true;
            statix.enable = true;
            deadnix.enable = true;
            mdformat.enable = true;
          };
        };
      };
    };
}
