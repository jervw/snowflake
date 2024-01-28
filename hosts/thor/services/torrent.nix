{...}: {
  services.nginx.virtualHosts = {
    "torrent.asgard".locations."/".proxyPass = "http://127.0.0.1:8080";
  };
}
