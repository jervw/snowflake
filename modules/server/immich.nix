{
  services.caddy.virtualHosts."media.jervw.dev".extraConfig = ''
    reverse_proxy http://thor:2995
    import cloudflare
  '';

  services.immich = {
    enable = false; # TODO Build failure
    mediaLocation = "/mnt/storage/Immich-Library";
    group = "media";
    port = 2995;
  };
}
