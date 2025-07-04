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

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  services = {
    udev = {
      packages = with pkgs; [vial];
    };
  };

  system.stateVersion = "24.05";
}
