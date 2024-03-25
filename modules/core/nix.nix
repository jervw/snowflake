_: {
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  # set flake location
  environment.variables = {FLAKE = "/nix/persist/system";};

  # tldr
  documentation = {
    enable = false;
  };

  nix = {
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 2d";
    };

    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";

    settings = {
      extra-experimental-features = ["flakes" "nix-command" "recursive-nix"];
      warn-dirty = false;
      auto-optimise-store = true;
      builders-use-substitutes = true;
      keep-outputs = true;
      allowed-users = ["@wheel"];
      trusted-users = ["root" "@wheel"];
      substituters = [
        "https://cache.nixos.org?priority=10"
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
        "https://helix.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      ];
    };
  };
}
