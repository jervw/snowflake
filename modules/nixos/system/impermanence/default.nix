{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkEnableOption forEach;
  inherit (config.${namespace}) user;
  cfg = config.${namespace}.system.impermanence;

  mkDirs = prefix: dirs: forEach dirs (x: "${prefix}${x}");
in {
  options.${namespace}.system.impermanence = {
    enable = mkEnableOption "impermanence";
  };
  config = mkIf cfg.enable {
    environment.persistence."/persist" = {
      hideMounts = true;
      directories =
        [
          "/tmp"
          "/var/db/sudo"
          "/var/lib/sbctl"
          "/var/log"
          "/var/tmp"
        ]
        ++ mkDirs "/etc/" ["NetworkManager" "nix" "ssh"]
        ++ mkDirs "/var/lib/" ["bluetooth" "docker" "libvirt" "nixos" "pipewire" "tailscale"]
        ++ mkDirs "/var/lib/systemd/" ["coredump" "timers"];
      files = ["/etc/machine-id"];
      users.${user.name} = {
        directories =
          [
            ".dots"
            ".var/app"
            "dev"
            "docs"
            "download"
            "games"
            "music"
            "other"
            "pics"
            "vids"
          ]
          ++ mkDirs ".cache/" ["nix" "noctalia"]
          ++ mkDirs ".config/" [
            "BeeperTexts"
            "Element"
            "Equicord"
            "FreeTube"
            "dconf"
            "discordcanary"
            "equibop"
            "fcitx5"
            "fractal"
            "harper-ls"
            "heroic"
            "net.imput.helium"
            "noctalia"
            "nushell"
            "obsidian"
            "obs-studio"
            "qt6ct"
            "rclone"
            "sh.cider.genten"
            "vesktop"
            "zed"
          ]
          ++ mkDirs ".local/share/" [
            "Anki2"
            "PrismLauncher"
            "helix"
            "Steam"
            "direnv"
            "fish"
            "lutris"
            "zed"
          ]
          ++ mkDirs ".local/state/" ["syncthing" "wireplumber" "noctalia"]
          ++ [
            {
              directory = ".gnupg";
              mode = "0700";
            }
            {
              directory = ".local/share/keyrings";
              mode = "0700";
            }
            {
              directory = ".ssh";
              mode = "0700";
            }
          ];
      };
    };
    systemd.tmpfiles.rules = mkDirs "L /var/lib/NetworkManager/" [
      "secret_key - - - - /persist/var/lib/NetworkManager/secret_key"
      "seen-bssids - - - - /persist/var/lib/NetworkManager/seen-bssids"
      "timestamps - - - - /persist/var/lib/NetworkManager/timestamps"
    ];
  };
}
