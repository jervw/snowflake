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
        jetbrains-mono
        noto-fonts-emoji
        noto-fonts-cjk-sans
        font-awesome
      ];
    };
  };
}
