{
  pkgs,
  user,
  ...
}: {
  environment.systemPackages = with pkgs; [
    virt-manager
  ];

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        ovmf.enable = true;
        runAsRoot = true;
      };
      onBoot = "ignore";
      onShutdown = "shutdown";
    };
  };

  networking.firewall.trustedInterfaces = ["virbr0"];
  users.groups.libvirtd.members = ["${user}"];
}
