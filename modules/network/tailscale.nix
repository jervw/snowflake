{
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
}
