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
    ];

    programs.zed-editor.installRemoteServer = true;

    snowflake = {
      programs = {
        editors = {
          helix = mkDefault enabled;
        };
        shells = {
          fish = mkDefault enabled;
          nushell = mkDefault enabled;
        };
        tools = {
          direnv = mkDefault enabled;
          fastfetch = mkDefault enabled;
          fzf = mkDefault enabled;
          gh = mkDefault enabled;
          jujutsu = mkDefault enabled;
          lazygit = mkDefault enabled;
          nix-your-shell = mkDefault enabled;
          yazi = mkDefault enabled;
          bat = mkDefault enabled;
          eza = mkDefault enabled;
          git = mkDefault enabled;
          starship = mkDefault enabled;
          zellij = mkDefault enabled;
        };
      };
    };
  };
}
