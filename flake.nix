{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    helix.url = "github:gj1118/helix";
    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";

    # TEMP
    nixpkgs-nvidia.url = "github:NixOS/nixpkgs/ab9ad415916a0fb89d1f539a9291d9737e95148e";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.darwin.follows = "";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
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

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mango = {
      url = "github:DreamMaoMao/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia-qs = {
      url = "github:noctalia-dev/noctalia-qs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
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
      };

      overlays = with inputs; [
        cachyos-kernel.overlays.pinned
        niri.overlays.niri
      ];

      systems.modules.nixos = with inputs; [
        agenix.nixosModules.default
        impermanence.nixosModule
        lanzaboote.nixosModules.lanzaboote
        nix-index.nixosModules.nix-index
        quadlet-nix.nixosModules.quadlet
      ];

      homes.modules = with inputs; [
        noctalia.homeModules.default
        niri.homeModules.niri
        mango.hmModules.mango
        zen-browser.homeModules.twilight
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
