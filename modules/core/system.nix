{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.default
    inputs.chaotic.nixosModules.default
  ];

  time.timeZone = "Europe/Helsinki";
  i18n.defaultLocale = "en_US.UTF-8";

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

  services.udev = {
    packages = with pkgs; [yubikey-personalization vial];
  };

  # allow users to mount fuse filesystems with allow_other
  programs.fuse.userAllowOther = true;

  system.stateVersion = "23.11";
}
