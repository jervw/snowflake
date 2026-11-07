{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.system.locale;
in {
  options.${namespace}.system.locale = {
    enable = lib.mkEnableOption " manage locale settings";
  };

  config = mkIf cfg.enable {
    i18n = {
      inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5 = {
          waylandFrontend = true;
          addons = with pkgs; [
            # fcitx5-mozc # build fails
            fcitx5-gtk
            fcitx5-fluent
          ];
        };
      };
      extraLocaleSettings = let
        localeCategories = [
          "LANG"
          "LANGUAGE"
          "LC_ADDRESS"
          "LC_COLLATE"
          "LC_CTYPE"
          "LC_IDENTIFICATION"
          "LC_MEASUREMENT"
          "LC_MESSAGES"
          "LC_MONETARY"
          "LC_NAME"
          "LC_NUMERIC"
          "LC_PAPER"
          "LC_TELEPHONE"
          "LC_TIME"
        ];
      in
        lib.genAttrs localeCategories (_: config.i18n.defaultLocale);
    };
  };
}
