{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    catppuccin.url = "github:catppuccin/nix";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    helix.url = "github:helix-editor/helix";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.darwin.follows = "";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/latest";
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

    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.quickshell.follows = "quickshell";
    };

    ssh-keys = {
      url = "https://github.com/jervw.keys";
      flake = false;
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
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
        permittedInsecurePackages = [
          "electron_36-bin-36.0.0-beta.6" # Vesktop TODO: Remove
        ];
      };

      systems.modules.nixos = with inputs; [
        agenix.nixosModules.default
        catppuccin.nixosModules.catppuccin
        chaotic.nixosModules.default
        disko.nixosModules.disko
        impermanence.nixosModule
        lanzaboote.nixosModules.lanzaboote
        nix-index.nixosModules.nix-index
        noctalia.nixosModules.default
        niri.nixosModules.niri
      ];

      homes.modules = with inputs; [
        catppuccin.homeModules.catppuccin
        zen-browser.homeModules.twilight
        noctalia.homeModules.default
      ];
    };
}
