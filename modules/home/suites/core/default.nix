{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkDefault;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.suites.core;
in {
  options.${namespace}.suites.core = {
    enable = lib.mkEnableOption "core applications ";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      btop
      caligula
      cloneit
      ripgrep
      rclone
      tldr
      fd
      nix-du
    ];

    snowflake = {
      programs = {
        terminal = {
          editors = {
            helix = mkDefault enabled;
          };
          shells = {
            fish = mkDefault enabled;
          };
          tools = {
            atuin = mkDefault enabled;
            direnv = mkDefault enabled;
            fastfetch = mkDefault enabled;
            gh = mkDefault enabled;
            lazygit = mkDefault enabled;
            yazi = mkDefault enabled;
            zoxide = mkDefault enabled;
            bat = mkDefault enabled;
            eza = mkDefault enabled;
            fzf = mkDefault enabled;
            git = mkDefault enabled;
            starship = mkDefault enabled;
            zellij = mkDefault enabled;
          };
        };
      };
    };
  };
}
