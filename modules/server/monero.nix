{...}: {
  networking.firewall = {
    allowedUDPPorts = [18080];
    allowedTCPPorts = [18080];
  };

  services.monero = {
    enable = true;
    dataDir = "/mnt/monero";
  };
}
