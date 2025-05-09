{
  config,
  inputs,
  lib,
  ...
}: {
  nixpkgs = {
    config = {
      allowUnfree = true;
      # TODO Not cool Sonarr
      permittedInsecurePackages = [
        "aspnetcore-runtime-6.0.36"
        "aspnetcore-runtime-wrapped-6.0.36"
        "dotnet-sdk-6.0.428"
        "dotnet-sdk-wrapped-6.0.428"
      ];
    };
  };

  programs = {
    command-not-found.enable = false;
    nh = {
      enable = true;
      flake = "/home/jervw/.dots";
      clean = {
        enable = true;
        extraArgs = "--keep-since 1d --keep 3";
      };
    };
    nix-index-database.comma.enable = true;
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: v: lib.isType "flake" v) inputs;
  in {
    # Pin the registry to avoid downloading and evaluating a new nixpkgs version every time
    registry = lib.mapAttrs (_: v: {flake = v;}) flakeInputs;

    # set the path for channels
    nixPath = lib.mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;

    # Remove channel functionality (nix-shell will still work thanks to above)
    channel.enable = false;

    optimise.automatic = true;
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";

    settings = {
      extra-experimental-features = ["flakes" "nix-command"];
      warn-dirty = false;
      builders-use-substitutes = true;
      keep-outputs = true;
      allowed-users = ["@wheel" "code-server"];
      trusted-users = ["root" "@wheel"];
      substituters = [
        "https://cache.nixos.org?priority=10"
        "https://nyx.chaotic.cx"
        "https://nix-community.cachix.org"
        "https://cache.soopy.moe"
      ];
      trusted-substituters = [
        "https://cache.soopy.moe"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.soopy.moe-1:0RZVsQeR+GOh0VQI9rvnHz55nVXkFardDqfm4+afjPo="
      ];
    };
  };
}
