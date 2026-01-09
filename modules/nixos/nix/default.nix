{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkForce;
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

      man.generateCaches = mkForce false;

      nixos = {
        enable = true;

        options = {
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
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
          "https://cache.garnix.io"
          "https://niri.cachix.org"
          "https://helix.cachix.org"
          "https://attic.xuyh0120.win/lantian"
          "https://cache.soopy.moe"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
          "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
          "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
          "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
          "cache.soopy.moe-1:0RZVsQeR+GOh0VQI9rvnHz55nVXkFardDqfm4+afjPo="
        ];
      };
      generateNixPathFromInputs = true;
      generateRegistryFromInputs = true;
      linkInputs = true;
    };
  };
}
