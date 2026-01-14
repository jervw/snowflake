{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.${namespace}.programs.tools.gh;
in {
  options.${namespace}.programs.tools.gh = {
    enable = mkEnableOption "Enable GitHub CLI";
  };

  config = mkIf cfg.enable {
    programs.gh = {
      enable = true;

      extensions = with pkgs; [
        gh-notify
        gh-eco
        gh-poi
      ];

      settings = {
        editor = "hx";
        prompt = "enabled";
        git_protocol = "ssh";
      };
    };
  };
}
