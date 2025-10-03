{
  inputs = {
    impermanence.url = "github:nix-community/impermanence";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    stylix.url = "github:danth/stylix";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.darwin.follows = "";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    comin = {
      url = "github:nlewo/comin";
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

    noctalia-shell = {
      url = "github:noctalia-dev/noctalia-shell";
      flake = false;
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
        chaotic.nixosModules.default
        comin.nixosModules.comin
        disko.nixosModules.disko
        home-manager.nixosModules.default
        impermanence.nixosModule
        lanzaboote.nixosModules.lanzaboote
        nix-index.nixosModules.nix-index
        stylix.nixosModules.stylix
      ];

      homes.modules = with inputs; [
        niri.homeModules.niri
        stylix.homeModules.stylix
        # zen-browser.homeModules.twilight
        zen-browser.homeModules.beta
      ];
    };
}
