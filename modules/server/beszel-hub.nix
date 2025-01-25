_: {
  services.caddy.virtualHosts."monitor.jervw.dev".extraConfig = ''
    reverse_proxy http://thor:8090
    import cloudflare
  '';
  services.beszel.server = {
    enable = true;
    host = "0.0.0.0";
    openFirewall = true;
  };
}
