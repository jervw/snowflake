{
  lib,
  config,
  inputs,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkForce;
  inherit (config.${namespace}) user;
in {
  config = {
    age.secrets.nix-access-tokens = {
      file = "${inputs.self}/secrets/nix-access-tokens.age";
      mode = "0400";
      owner = user.name;
    };

    environment.systemPackages = [
      inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.celler.packages.${pkgs.stdenv.hostPlatform.system}.celler
    ];

    programs = {
      command-not-found.enable = false;
      nh = {
        enable = true;
        flake = "/home/${user.name}/.dots";
        clean = {
          enable = true;
          extraArgs = "--keep-since 1d --keep 3";
        };
      };
      nix-index-database.comma.enable = true;
    };

    documentation = {
      doc.enable = false;
      info.enable = false;

      man.cache.enable = mkForce false;

      nixos = {
        enable = true;

        options = {
          splitBuild = true;
        };
      };
    };

    nix = {
      channel.enable = false;
      extraOptions = ''
        !include ${config.age.secrets.nix-access-tokens.path}
      '';
      settings = {
        extra-experimental-features = ["flakes" "nix-command"];
        warn-dirty = false;
        keep-outputs = true;
        auto-optimise-store = true;
        allowed-users = ["@wheel"];
        trusted-users = ["root" "@wheel"];
        accept-flake-config = true;
        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
          "https://attic.xuyh0120.win/lantian" # CachyOS kernels
          "https://cache.soopy.moe" # Linux T2
          "https://noctalia.cachix.org"
          "https://cache.nixos-cuda.org"
          "https://cache.jervw.dev/nix"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
          "cache.soopy.moe-1:0RZVsQeR+GOh0VQI9rvnHz55nVXkFardDqfm4+afjPo="
          "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
          "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
          "nix:IbdGpiigjEu45Imugs8y6OM6mDSbYr0Zf3Q2E6yz+Xc="
        ];
      };
      generateNixPathFromInputs = true;
      generateRegistryFromInputs = true;
      linkInputs = true;
    };
  };
}
