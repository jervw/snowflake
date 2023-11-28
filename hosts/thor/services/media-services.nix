{
  services = {
    radarr.enable = true;
    sonarr.enable = true;
    prowlarr.enable = true;
    bazarr.enable = true;

    nginx.virtualHosts = {
      "radarr.asgard".locations."/".proxyPass = "http://127.0.0.1:7878";
      "sonarr.asgard".locations."/".proxyPass = "http://127.0.0.1:8989";
      "prowlarr.asgard".locations."/".proxyPass = "http://127.0.0.1:9696";
      "bazarr.asgard".locations."/".proxyPass = "http://127.0.0.1:6767";
    };
  };
}
