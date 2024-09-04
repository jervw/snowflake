{
  # Other out of tree services which do not have NixOS modules
  services.caddy.caddy.virtualHosts = {
    # Immich
    "media.jervw.dev".extraConfig = ''
      reverse_proxy http://thor:2283
      import cloudflare
    '';

    # Speedtest-tracker
    "speedtest.jervw.dev".extraConfig = ''
      reverse_proxy http://thor:8095
      import cloudflare
    '';
  };
}
