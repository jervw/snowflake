{
  pkgs,
  user,
  ...
}: {
  environment.systemPackages = with pkgs; [
    docker-compose
    distrobox
    lazydocker
  ];

  virtualisation.oci-containers.backend = "docker";
  virtualisation.docker = {
    enable = true;
  };

  users.groups.docker.members = ["${user}"];
}
