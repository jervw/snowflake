{
  services.caddy.virtualHosts."media.jervw.dev".extraConfig = ''
    reverse_proxy http://thor:2995
    import cloudflare
  '';

  services.immich = {
    enable = true;
    openFirewall = true;
    mediaLocation = "/mnt/storage/Immich-Library";
    group = "media";
    host = "0.0.0.0";
    port = 2995;
  };
}
