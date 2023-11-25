{config, ...}: {
  virtualisation.oci-containers.containers.qbittorrent = {
    image = "j4ym0/pia-qbittorrent";
    environmentFiles = [config.age.secrets.pia.path];
    volumes = [
      # "/mnt/ext:/ext:rw"
      "pia_config:/config:rw"
    ];
    ports = [
      "8888:8888/tcp"
    ];
    extraOptions = ["--cap-add=NET_ADMIN"];
  };
}
