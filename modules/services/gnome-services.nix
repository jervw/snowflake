{pkgs, ...}: {
  services = {
    dbus.packages = with pkgs; [
      gnome-settings-daemon
    ];
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
  };

  programs.seahorse.enable = true;
}
