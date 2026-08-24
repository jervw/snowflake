{
  inputs = {
    ghostty.url = "github:ghostty-org/ghostty";
    helix.url = "github:gj1118/helix";
    nixcord.url = "github:FlameFlag/nixcord";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";
    nix-gaming.url = "github:fufexan/nix-gaming";

    celler = {
      url = "github:celler-cache/celler";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.darwin.follows = "";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix-notes = {
      url = "gitlab:/ArkHost/HelixNotes";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
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

    snowfall-lib = {
      url = "github:anntnzrb/snowfall-lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ssh-keys = {
      url = "https://github.com/jervw.keys";
      flake = false;
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
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

      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      systems.modules.nixos = with inputs; [
        agenix.nixosModules.default
        celler.nixosModules.cellerd
        impermanence.nixosModule
        lanzaboote.nixosModules.lanzaboote
        nix-index.nixosModules.nix-index
        quadlet-nix.nixosModules.quadlet
        nix-gaming.nixosModules.pipewireLowLatency
        nix-gaming.nixosModules.platformOptimizations
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
