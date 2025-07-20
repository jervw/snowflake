{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkDefault;
  user = config.${namespace}.user;
in {
  config = {
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

      man.generateCaches = mkDefault true;

      nixos = {
        enable = true;

        options = {
          warningsAreErrors = false; # TODO Make it true?
          splitBuild = true;
        };
      };
    };

    nix = {
      channel.enable = false;

      optimise = {
        automatic = true;
        dates = ["04:00"];
      };

      # Low priority builds to preserve system resources
      daemonCPUSchedPolicy = "batch";
      daemonIOSchedClass = "idle";
      daemonIOSchedPriority = 7;

      settings = {
        extra-experimental-features = ["flakes" "nix-command"];
        warn-dirty = false;
        keep-outputs = true;
        allowed-users = ["@wheel"];
        trusted-users = ["root" "@wheel"];
        substituters = [
          "https://cache.nixos.org?priority=10"
          "https://nyx.chaotic.cx"
          "https://nix-community.cachix.org"
          "https://cache.soopy.moe"
          "https://niri.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "cache.soopy.moe-1:0RZVsQeR+GOh0VQI9rvnHz55nVXkFardDqfm4+afjPo="
          "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
        ];
      };
      generateNixPathFromInputs = true;
      generateRegistryFromInputs = true;
      linkInputs = true;
    };
  };
}
