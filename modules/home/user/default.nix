{
  config,
  lib,
  pkgs,
  osConfig ? {},
  namespace,
  ...
}: let
  inherit
    (lib)
    types
    mkIf
    getExe
    ;
  inherit (lib.${namespace}) mkOpt enabled;

  cfg = config.${namespace}.user;
in {
  options.${namespace}.user = with lib; {
    enable = mkOpt types.bool false "Whether to configure the user account.";
    name = mkOpt str "jervw" "The name to use for the user account.";
    fullName = mkOpt str "Jere Vuola" "The full name of the user.";
    email = mkOpt str "jervw@pm.me" "The email of the user.";
  };

  config = mkIf cfg.enable {
    home = {
      shellAliases = {
        whereami = "${getExe pkgs.curl} ipinfo.io/city";
        myip = "${getExe pkgs.curl} ifconfig.me";

        sl = "ls";
        flake = "nix flake";
      };
      home.stateVersion = lib.mkDefault (osConfig.system.stateVersion or "24.05");
    };
    programs.home-manager = enabled;
  };
}
