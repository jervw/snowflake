
{ config, pkgs, ...}:

{
  imports = [ ./hardware-configuration.nix ];
  
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Helsinki";
  i18n.defaultLocale = "en_US.UTF-8";

  programs.fish.enable = true;

  users.users.jervw = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "jervw";
  };

  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  services.openssh.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "23.05";
}
