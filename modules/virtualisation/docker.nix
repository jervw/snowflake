{config, pkgs, user, ... }:

{  
  # Docker
  virtualisation.docker = {
    enable = true;
    enableNvidia = true;
  };

  users.groups.docker.members = [ "${user}" ];
 
}
