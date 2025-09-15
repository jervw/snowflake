{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.terminal.shells.fish;
  user = config.${namespace}.user;
in {
  options.${namespace}.programs.terminal.shells.fish = {
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
