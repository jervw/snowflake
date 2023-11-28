{
  networking.firewall.allowedUDPPorts = [53];
  services.adguardhome = {
    enable = true;
  };

  # Reverse proxy
  services.nginx.virtualHosts."adguard.asgard" = {
    locations."/".proxyPass = "http://127.0.0.1:3000";
  };
}
