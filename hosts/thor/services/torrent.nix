{
  config,
  lib,
  ...
}: {
  virtualisation.oci-containers.containers.qbittorrent = {
    image = lib.mkForce "j4ym0/pia-qbittorrent";
    environmentFiles = [config.age.secrets.pia.path];
    volumes = [
      "pia_config:/config"
    ];
    ports = [
      "8888:8888"
    ];
    extraOptions = ["--cap-add=NET_ADMIN"];
  };

  services.nginx.virtualHosts = {
    "torrent.asgard".locations."/".proxyPass = "http://127.0.0.1:8888";
  };
}
