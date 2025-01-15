{
  lib,
  inputs,
  self,
  ...
}: let
  system = "x86_64-linux";

  additionalPackages = pkgs:
    with pkgs; [
      git
      helix
    ];

  mkIso = modules:
    (inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
        "${self}/modules/network/networkmanager.nix"

        (import "${self}/modules/core/openssh.nix" {
          inherit lib inputs;
          user = "nixos";
        })

        modules
      ];
    })
    .config
    .system
    .build
    .isoImage;
in {
  flake.images = {
    minimal-iso = mkIso ({pkgs, ...}: {
      environment.systemPackages = additionalPackages pkgs;
      programs.fish.enable = true;
      nix.settings.experimental-features = ["nix-command" "flakes"];

      services.getty.helpLine = let
        packages =
          builtins.concatStringsSep "\n  - "
          (map (p: "${p.name}") (additionalPackages pkgs));
      in ''
        Welcome to NixOS Live ISO by jervw!

        Additional packages available:
          - ${packages}

        Note: Fish shell is available, type 'fish' to use it.
      '';
    });
  };
}
