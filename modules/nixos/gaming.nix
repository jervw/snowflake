{
  pkgs,
  config,
  ...
}: let
  hyprctl = "${config.programs.hyprland.package}/bin/hyprctl";
  gamemodeStart = pkgs.writeShellScript "gamemode-start-script" ''
    ${pkgs.libnotify}/bin/notify-send 'GameMode started'
    ${hyprctl} --instance 0 --batch "\
        keyword monitor HDMI-A-1, disable;\
        keyword animations:enabled 0;\
        keyword decoration:drop_shadow 0;\
        keyword decoration:blur:enabled 0;\
        keyword general:border_size 1;\
        keyword decoration:rounding 0"
  '';

  gamemodeEnd = pkgs.writeShellScript "gamemode-end-script" ''
    ${pkgs.libnotify}/bin/notify-send 'GameMode stopped'
    ${hyprctl} reload
  '';
in {
  programs.steam = {
    enable = true;
    extest.enable = true;
    extraPackages = [pkgs.mangohud];
    extraCompatPackages = [pkgs.proton-ge-bin];
  };

  # TODO Add GPU overclocking when there is a easy way to do it on Wayland + NVIDIA
  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      general = {
        renice = 10;
      };
      custom = {
        start = gamemodeStart.outPath;
        end = gamemodeEnd.outPath;
      };
    };
  };
}
