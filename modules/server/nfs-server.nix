_: {
  services = {
    nfs = {
      server = {
        enable = true;
        exports = ''
          /mnt/storage/NAS 100.64.0.0/10(rw,no_subtree_check,insecure,async)
        '';
      };
    };
  };
}
