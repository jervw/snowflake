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
      ++ forEach ["NetworkManager" "nix" "ssh" "secureboot"] (x: "/etc/${x}")
      ++ forEach ["tailscale" "bluetooth" "nixos" "pipewire" "libvirt" "docker"] (x: "/var/lib/${x}")
      ++ forEach ["coredump" "timers"] (x: "/var/lib/systemd/${x}");
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
        ++ forEach ["dconf" "rclone" "sh.cider.genten" "nushell" "vesktop" "obs-studio" "github-copilot" "zed" "gh"] (
          x: ".config/${x}"
        )
        ++ forEach ["nix" "zen"] (
          x: ".cache/${x}"
        )
        ++ forEach ["direnv" "PrismLauncher" "zed" "Steam"] (x: ".local/share/${x}")
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
}
