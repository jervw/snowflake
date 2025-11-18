_: {
  config = {
    environment.pathsToLink = ["/share/applications" "/share/xdg-desktop-portal"];
    home-manager = {
      backupFileExtension = "hm.old";
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };
}
