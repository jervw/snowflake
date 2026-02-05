{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkEnableOption forEach;
  inherit (config.${namespace}) user;
  cfg = config.${namespace}.system.impermanence;

  # reduce duplication
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
          "/var/log"
          "/var/tmp"
          "/var/db/sudo"
          "/var/lib/sbctl"
        ]
        ++ mkDirs "/etc/" ["NetworkManager" "nix" "ssh"]
        ++ mkDirs "/var/lib/" ["tailscale" "bluetooth" "nixos" "pipewire" "libvirt" "docker"]
        ++ mkDirs "/var/lib/systemd/" ["coredump" "timers"];

      files = ["/etc/machine-id"];

      users.${user.name} = {
        files = [".config/ghostty/themes/noctalia"];

        directories =
          [
            "download"
            "music"
            "dev"
            "docs"
            "pics"
            "vids"
            "sync"
            "other"
            "games"
            ".dots"
            ".logseq"
          ]
          ++ mkDirs ".config/" [
            "dconf"
            "heroic"
            "fractal"
            "rclone"
            "sh.cider.genten"
            "nushell"
            "BraveSoftware"
            "vesktop"
            "equibop"
            "obs-studio"
            "noctalia"
            "zed"
            "FreeTube"
            "harper-ls"
            "BeeperTexts"
            "fcitx5"
            "qt6ct"
            "Logseq"
          ]
          ++ mkDirs ".cache/" ["nix" "BraveSoftware" "noctalia"]
          ++ mkDirs ".local/share/" [
            "Anki2"
            "direnv"
            "PrismLauncher"
            "BraveSoftware"
            "zed"
            "Steam"
            "fish"
            "lutris"
          ]
          ++ mkDirs ".local/state/" ["syncthing" "wireplumber"]
          ++ [
            {
              directory = ".ssh";
              mode = "0700";
            }
            {
              directory = ".gnupg";
              mode = "0700";
            }
            {
              directory = ".local/share/keyrings";
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
