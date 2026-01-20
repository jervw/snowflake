{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf forEach;

  cfg = config.${namespace}.system.impermanence;
  inherit (config.${namespace}) user;
in {
  options.${namespace}.system.impermanence = {
    enable = lib.mkEnableOption "Enable impermanence";
  };

  # TODO: Make something cool with this
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
        ++ forEach ["NetworkManager" "nix" "ssh"] (x: "/etc/${x}")
        ++ forEach ["tailscale" "bluetooth" "nixos" "pipewire" "libvirt" "docker"] (x: "/var/lib/${x}")
        ++ forEach ["coredump" "timers"] (x: "/var/lib/systemd/${x}");
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
          ++ forEach [
            "dconf"
            "heroic"
            "obsidian"
            "rclone"
            "sh.cider.genten"
            "nushell"
            "BraveSoftware"
            "vesktop"
            "obs-studio"
            "noctalia"
            "zed"
            "FreeTube"
            "harper-ls"
            "BeeperTexts"
            "fcitx5"
            "qt6ct"
            "Logseq"
          ] (
            x: ".config/${x}"
          )
          ++ forEach ["nix" "BraveSoftware" "noctalia"] (
            x: ".cache/${x}"
          )
          ++ forEach [
            "Anki2"
            "atuin"
            "direnv"
            "PrismLauncher"
            "BraveSoftware"
            "zed"
            "Steam"
            "fish"
            "lutris"
          ] (x: ".local/share/${x}")
          ++ forEach ["syncthing" "wireplumber"] (x: ".local/state/${x}")
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

    systemd.tmpfiles.rules = [
      "L /var/lib/NetworkManager/secret_key - - - - /persist/var/lib/NetworkManager/secret_key"
      "L /var/lib/NetworkManager/seen-bssids - - - - /persist/var/lib/NetworkManager/seen-bssids"
      "L /var/lib/NetworkManager/timestamps - - - - /persist/var/lib/NetworkManager/timestamps"
    ];
  };
}
