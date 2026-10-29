{
  inputs = {
    ghostty.url = "github:ghostty-org/ghostty";
    helix.url = "github:jervw/helix";
    # nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixos-hardware.url = "github:soopyc/nixos-hardware/apple-t2-updates"; # TODO: Remove after #1934 merged
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";
    nix-gaming.url = "github:fufexan/nix-gaming";
    noctalia.url = "github:noctalia-dev/noctalia-shell";
    millennium.url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";

    # No releases upstream. Pinned with its own nixpkgs so `flake update`
    # doesn't change the derivation and force a rebuild; bump the rev manually.
    celler.url = "github:celler-cache/celler/2d5be60ca34a290a1a6c5ce34b3843db67d12f70";

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
