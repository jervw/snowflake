{
  inputs,
  lib,
  user,
  ...
}: let
  inherit (lib) forEach;
in {
  imports = [inputs.impermanence.nixosModule];

  environment.persistence."/persist" = {
    hideMounts = true;
    directories =
      [
        "/tmp"
        "/var/log"
        "/var/tmp"
        "/var/db/sudo"
      ]
      ++ forEach ["nixos" "NetworkManager" "nix" "ssh" "secureboot"] (x: "/etc/${x}")
      ++ forEach ["tailscale" "bluetooth" "nixos" "pipewire" "libvirt" "docker"] (x: "/var/lib/${x}");
    files = ["/etc/machine-id"];
    users.${user} = {
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
          ".dots"
          ".zen"
        ]
        ++ forEach ["dconf" "rclone" "Yubico" "sh.cider.electron" "syncthing" "fish" "vesktop" "obs-studio" "github-copilot" "zed" "gh" "FreeTube"] (
          x: ".config/${x}"
        )
        ++ forEach ["nix" "zen"] (
          x: ".cache/${x}"
        )
        ++ forEach ["fish" "fractal" "direnv" "PrismLauncher" "zed"] (x: ".local/share/${x}")
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
}
