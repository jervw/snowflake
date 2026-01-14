{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.shells.fish;
  inherit (config.${namespace}) user;
in {
  options.${namespace}.programs.shells.fish = {
    enable = lib.mkEnableOption "Enable Fish shell";
  };

  config = mkIf cfg.enable {
    programs.fish = {
      enable = true;
      useBabelfish = true;
    };
    users.users.${user.name} = {
      shell = pkgs.fish;
    };
  };
}
