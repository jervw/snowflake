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
          "/var/db/sudo"
          "/var/lib/sbctl"
          "/var/log"
          "/var/tmp"
        ]
        ++ mkDirs "/etc/" ["NetworkManager" "nix" "ssh"]
        ++ mkDirs "/var/lib/" ["bluetooth" "docker" "flatpak" "libvirt" "nixos" "pipewire" "tailscale"]
        ++ mkDirs "/var/lib/systemd/" ["coredump" "timers"];
      files = ["/etc/machine-id"];
      users.${user.name} = {
        files = [".config/ghostty/themes/noctalia"];
        directories =
          [
            ".dots"
            ".factorio"
            ".logseq"
            ".var/app"
            "dev"
            "docs"
            "download"
            "games"
            "music"
            "other"
            "pics"
            "sync"
            "vids"
          ]
          ++ mkDirs ".cache/" ["nix" "noctalia"]
          ++ mkDirs ".config/" [
            "BeeperTexts"
            "Element"
            "FreeTube"
            "Logseq"
            "dconf"
            "equibop"
            "fcitx5"
            "fractal"
            "harper-ls"
            "heroic"
            "noctalia"
            "nushell"
            "obs-studio"
            "qt6ct"
            "rclone"
            "vesktop"
            "zed"
            "zen"
          ]
          ++ mkDirs ".local/share/" [
            "Anki2"
            "PrismLauncher"
            "Steam"
            "direnv"
            "fish"
            "flatpak"
            "lutris"
            "zed"
          ]
          ++ mkDirs ".local/state/" ["syncthing" "wireplumber"]
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
