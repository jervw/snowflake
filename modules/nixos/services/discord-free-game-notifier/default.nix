{
  config,
  inputs,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.services.discord-free-game-notifier;
in {
  options.${namespace}.services.discord-free-game-notifier.enable =
    lib.mkEnableOption "Discord free game notifier service";

  config = mkIf cfg.enable {
    snowflake.virtualisation.quadlet.enable = true;

    age.secrets.discord-free-game = {
      file = "${inputs.self}/secrets/discord-free-game.age";
      mode = "0400";
      owner = "containers";
      group = "containers";
    };

    virtualisation.quadlet = let
      inherit (config.virtualisation.quadlet) volumes;
    in {
      volumes."discord-free-game-notifier" = {};

      containers.discord-free-game-notifier = {
        autoStart = true;
        rootlessConfig.uid = config.users.users.containers.uid;

        serviceConfig = {
          Restart = "always";
          RestartSec = "10s";
        };

        containerConfig = {
          image = "ghcr.io/thelovinator1/discord-free-game-notifier:master";
          environmentFiles = [config.age.secrets.discord-free-game.path];
          volumes = [
            "${volumes."discord-free-game-notifier".ref}:/home/botuser/.local/share/discord_free_game_notifier"
          ];
        };
      };
    };
  };
}
