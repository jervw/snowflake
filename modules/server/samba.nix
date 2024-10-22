{
  services = {
    samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "thor";
          "netbios name" = "thor";
          "security" = "user";
          "use sendfile" = "yes";
          "max protocol" = "SMB3";
          "guest account" = "nobody";
          "map to guest" = "Bad User";
        };
        public = {
          "path" = "/mnt/extra/NAS";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "nobody";
          "force group" = "nogroup";
          "comment" = "Public samba share.";
        };
      };
    };
    samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
  };
}
