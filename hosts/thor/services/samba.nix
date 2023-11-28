{
  services.samba = {
    enable = true;
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      server role = standalone server
      vfs objects = catia fruit streams_xattr

      pam password change = yes
      map to guest = bad user
      usershare allow guests = yes
      create mask = 0664
      force create mode = 0664
      directory mask = 0775
      force directory mode = 0775
      follow symlinks = yes
      load printers = no
      printing = bsd
      printcap name = /dev/null
      disable spoolss = yes
      strict locking = no
      aio read size = 0
      aio write size = 0
      vfs objects = acl_xattr catia fruit streams_xattr
      inherit permissions = yes

      # Security
      client ipc max protocol = SMB3
      client ipc min protocol = SMB2_10
      client max protocol = SMB3
      client min protocol = SMB2_10
      server max protocol = SMB3
      server min protocol = SMB2_10

      # Time Machine
      fruit:delete_empty_adfiles = yes
      fruit:time machine = yes
      fruit:veto_appledouble = no
      fruit:wipe_intentionally_left_blank_rfork = yes
      fruit:posix_rename = yes
      fruit:metadata = stream
    '';

    shares = {
      public = {
        path = "/mnt/storage/NAS/Public";
        browseable = "yes";
        "read only" = "no";

        # This is public, everybody can access.
        "guest ok" = "yes";
        "force user" = "nobody";
        "force group" = "users";

        "veto files" = "/.apdisk/.DS_Store/.TemporaryItems/.Trashes/desktop.ini/ehthumbs.db/Network Trash Folder/Temporary Items/Thumbs.db/";
        "delete veto files" = "yes";
      };
      jervw = {
        path = "/mnt/storage/NAS/Private";
        browseable = "yes";
        "read only" = "no";

        # Make this private
        "guest ok" = "no";
        "valid users" = "jervw";

        "veto files" = "/.apdisk/.DS_Store/.TemporaryItems/.Trashes/desktop.ini/ehthumbs.db/Network Trash Folder/Temporary Items/Thumbs.db/";
        "delete veto files" = "yes";
      };
    };
  };
}
