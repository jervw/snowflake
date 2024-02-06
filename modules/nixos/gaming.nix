{pkgs, ...}: {
  programs.gamemode.enable = true;

  hardware.xone.enable = true;
  environment.systemPackages = with pkgs; [linuxKernel.packages.linux_zen.xone];
}
