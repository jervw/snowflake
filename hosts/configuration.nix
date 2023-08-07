# Universal configuration file for all hosts

{ config, lib, pkgs, user, ... }:

{
  imports = [ ./../modules/virtualisation ];

  programs.fish.enable = true;

  # User management
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "doas" "libvirtd" "docker" ];
    shell = pkgs.fish;
    initialPassword = "password";
  };

  # Set the localisation
  time.timeZone = "Europe/Helsinki";
  i18n.defaultLocale = "en_US.UTF-8";

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    sudo.enable = false;

    pam = {
      services = {
        login.u2fAuth = true;
      };
    };

    doas = {
      enable = true;
      wheelNeedsPassword = false;

      extraRules = [{
        users = [ user ];
        keepEnv = true;
        noPass = true;
      }];
    };
  };

  environment = {
    systemPackages = with pkgs; [
      git
      killall
      tmux
      wget
      nano
      gsettings-desktop-schemas
      glib
      pkgconfig
      gnome.seahorse
    ];
  };

  # Font management
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    font-awesome
    corefonts
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 2d";
    };
  };

  system.stateVersion = "22.11";
}
