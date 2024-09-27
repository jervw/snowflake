{
  self,
  config,
  ...
}: {
  networking.firewall = {
    trustedInterfaces = ["tailscale0"];
    checkReversePath = "loose";
  };

  age.secrets.tailscale.file = "${self}/secrets/tailscale.age";
  services.tailscale = {
    enable = true;
    authKeyFile = config.age.secrets.tailscale.path;
    openFirewall = true;
  };
}
