_: {
  services.caddy.virtualHosts."code.jervw.dev".extraConfig = ''
    reverse_proxy http://thor:4444
    import cloudflare
  '';

  services.code-server = {
    enable = true;
    host = "0.0.0.0";
    disableTelemetry = true;
  };
}
