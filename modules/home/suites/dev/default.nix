{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.suites.dev;
in {
  options.${namespace}.suites.dev = {
    enable = lib.mkEnableOption "dev applications ";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # Rust
      rustc
      cargo
      rustfmt
      clippy

      # C/C++
      gcc
      cmake
      gnumake
      ninja
      meson

      # Web
      deno

      # Misc
      just
    ];

    snowflake.programs.editors = {
      zed.enable = true;
      helix.withLsp = true;
    };
  };
}
