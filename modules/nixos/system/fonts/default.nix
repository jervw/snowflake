{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.system.fonts;
in {
  options.${namespace}.system.fonts = {
    enable = lib.mkEnableOption " manage fonts";
  };

  config = mkIf cfg.enable {
    fonts = {
      enableDefaultPackages = false;
      packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        jetbrains-mono
        noto-fonts
        noto-fonts-color-emoji
        noto-fonts-cjk-sans
        font-awesome
        material-symbols
      ];
    };
  };
}
