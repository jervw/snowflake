{pkgs, ...}: {
  environment = {
    systemPackages = with pkgs; [
      git
      glib
      killall
      python3
      unzip
      zip
      zfs
      file
      tpm2-tss
      nh
      jq
      unar
    ];
  };
}
