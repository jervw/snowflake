{pkgs, ...}: {
  services = {
    dbus.packages = with pkgs; [
      # gnome-settings-daemon
    ];
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
  };

  programs.seahorse.enable = true;

  # FIX very haram, trying to troubleshoot why keyring doesnt unlock on login
  security.pam.services."*".enableGnomeKeyring = true;
}
