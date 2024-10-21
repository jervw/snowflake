{
  networking.firewall.allowedTCPPorts = [443];

  # Other out of tree services which do not have NixOS modules
  services.caddy.virtualHosts = {
    # Speedtest-tracker
    "speedtest.jervw.dev".extraConfig = ''
      reverse_proxy http://thor:8095
      import cloudflare
    '';
    # YliProxy
    "lol.jervw.dev".extraConfig = ''
      reverse_proxy http://0.0.0.0:8099
      import cloudflare
    '';
  };
}
