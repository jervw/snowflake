{
  services.caddy.virtualHosts."home.jervw.dev".extraConfig = ''
    reverse_proxy http://thor:5678
    import cloudflare
  '';

  services.glances = {
    enable = true;
    openFirewall = true;
    settings = {
      host = "0.0.0.0";
      port = 5678;
    };
  };
}
