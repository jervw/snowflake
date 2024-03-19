{
  services.caddy.virtualHosts."adguard.jervw.dev".extraConfig = ''
    reverse_proxy http://thor:3000
    import cloudflare
  '';

  networking.firewall = {
    allowedUDPPorts = [53]; # DNS resolver.
  };

  services.adguardhome = {
    enable = true;
    openFirewall = true;
  };
}
