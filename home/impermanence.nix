{
  lib,
  user,
  inputs,
  ...
}: let
  inherit (lib) forEach;
in {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  home.persistence."/nix/persist/home/${user}" = {
    allowOther = true;
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
      ]
      ++ forEach ["dconf" "rclone" "Yubico" "sh.cider.electron" "syncthing" "fish" "vesktop" "obs-studio" "github-copilot" "zed"] (
        x: ".config/${x}"
      )
      ++ forEach ["nix" "mozilla" "zen"] (
        x: ".cache/${x}"
      )
      ++ forEach ["fish" "direnv" "keyrings" "PrismLauncher" "zed"] (x: ".local/share/${x}")
      ++ [".ssh" ".gnupg" ".mozilla" ".zen"];
  };
}
