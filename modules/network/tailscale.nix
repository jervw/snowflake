{
  pkgs,
  self,
  config,
  user,
  lib,
  ...
}: let
  inherit (config.networking) hostName;
in {
  networking.firewall = {
    trustedInterfaces = ["tailscale0"];
    checkReversePath = "loose";
  };

  age.secrets.tailscale.file = "${self}/secrets/tailscale.age";
  services.tailscale = {
    enable = true;
    authKeyFile = config.age.secrets.tailscale.path;
    openFirewall = true;
    extraSetFlags = ["--operator=${user}"];
    extraUpFlags = lib.optionals (hostName == "thor") [
      "--accept-dns=false"
      "--ssh"
    ];
  };

  # NAS throught Tailscale
  environment.systemPackages = with pkgs; [nfs-utils];
  boot.initrd = {
    supportedFilesystems = ["nfs"];
    kernelModules = ["nfs"];
  };

  fileSystems."/mnt/share" = {
    device = "thor:/mnt/storage/NAS";
    fsType = "nfs";
    options = ["rw" "noauto" "x-systemd.automount" "x-systemd.idle-timeout=600"];
  };
}
