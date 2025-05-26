{
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # Launchers
    lutris
    heroic
    bottles

    # Emulators
    rpcs3
    shadps4

    # Misc
    r2modman
    mangohud
    cartridges
    gpu-screen-recorder-gtk
  ];

  programs = {
    steam = {
      enable = true;
      extest.enable = true;
      localNetworkGameTransfers.openFirewall = true;
      dedicatedServer.openFirewall = true;
      extraPackages = [pkgs.mangohud];
      extraCompatPackages = [pkgs.proton-ge-bin];
    };

    gpu-screen-recorder = {
      enable = true;
    };

    gamescope = {
      enable = true;
    };

    # TODO Add GPU overclocking when there is a easy way to do it on Wayland + NVIDIA
    gamemode = {
      enable = true;
      enableRenice = true;
      settings = let
        primaryMonitor = "DP-1";
        hyprctl = "${config.programs.hyprland.package}/bin/hyprctl";
        gamemodeStart = pkgs.writeShellScript "gamemode-start-script" ''
          ${pkgs.libnotify}/bin/notify-send 'GameMode started'

          # Set Xwayland primary monitor
          ${pkgs.xorg.xrandr}/bin/xrandr --output ${primaryMonitor} --primary

          # Disable Hyprland bling bling
          ${hyprctl} --instance 0 --batch "\
              keyword animations:enabled 0;\
              keyword decoration:drop_shadow 0;\
              keyword decoration:blur:enabled 0;\
              keyword general:border_size 1;\
              keyword decoration:rounding 0"
        '';

        gamemodeEnd = pkgs.writeShellScript "gamemode-end-script" ''
          ${pkgs.libnotify}/bin/notify-send 'GameMode stopped'
          ${hyprctl} --instance 0 reload
        '';
      in {
        general = {
          renice = 10;
        };
        custom = {
          start = gamemodeStart.outPath;
          end = gamemodeEnd.outPath;
        };
      };
    };
  };
}
