{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) types mkIf mkForce;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.hardware.audio;
in {
  options.${namespace}.hardware.audio = with types; {
    enable = lib.mkEnableOption "audio support";
    alsa-monitor = mkOpt attrs {} "Alsa configuration.";
    extra-packages = mkOpt (listOf package) [
      pkgs.qjackctl
      pkgs.easyeffects
    ] "Additional packages to install.";
    modules = mkOpt (listOf attrs) [] "Audio modules to pass to Pipewire as `context.modules`.";
    nodes = mkOpt (listOf attrs) [] "Audio nodes to pass to Pipewire as `context.objects`.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [
        pulsemixer
        pavucontrol
        crosspipe
      ]
      ++ cfg.extra-packages;

    snowflake = {
      user.extraGroups = ["audio"];
    };

    # Disable audio power saving to prevent crackling
    boot.extraModprobeConfig = ''
      options snd_hda_intel power_save=0
    '';

    security.rtkit.enable = true;

    services = {
      pipewire = {
        enable = true;
        alsa.enable = true;
        audio.enable = true;
        jack.enable = true;
        pulse.enable = true;
        wireplumber.enable = true;

        # NOTE: Depends on nix-gaming flake
        lowLatency.enable = true;
      };
      pulseaudio.enable = mkForce false;
    };
  };
}
