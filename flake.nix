{
  inputs = {
    ghostty.url = "github:ghostty-org/ghostty";
    helix.url = "github:jervw/helix";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";
    nix-gaming.url = "github:fufexan/nix-gaming";
    noctalia.url = "github:noctalia-dev/noctalia-shell";
    millennium.url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";

    celler = {
      url = "github:celler-cache/celler";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixcord = {
      url = "github:FlameFlag/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snowfall-lib = {
      url = "github:anntnzrb/snowfall-lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tether = {
      url = "github:zackb/tether";
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

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;

      src = ./.;

      snowfall = {
        namespace = "nietos";
        meta = {
          name = "nietos";
          title = "Nietos";
        };
      };

      channels-config = {
        allowUnfree = true;
      };

      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      overlays = [
        inputs.millennium.overlays.default
      ];

      systems.modules.nixos = with inputs; [
        agenix.nixosModules.default
        celler.nixosModules.cellerd
        impermanence.nixosModule
        nix-index.nixosModules.nix-index
        quadlet-nix.nixosModules.quadlet
        tether.nixosModules.default
        nix-gaming.nixosModules.pipewireLowLatency
        nix-gaming.nixosModules.platformOptimizations
      ];

      homes.modules = with inputs; [
        agenix.homeManagerModules.default
        noctalia.homeModules.default
        nixcord.homeModules.nixcord
        zen-browser.homeModules.twilight-official
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
