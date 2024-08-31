{pkgs, ...}: let
  gamemodeStart = pkgs.writeShellScript "gamemode-start-script" ''
    ${pkgs.libnotify}/bin/notify-send 'GameMode started'
  '';
  gamemodeEnd = pkgs.writeShellScript "gamemode-end-script" ''
    ${pkgs.libnotify}/bin/notify-send 'GameMode stopped'
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
