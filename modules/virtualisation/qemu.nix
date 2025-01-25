{
  pkgs,
  user,
  ...
}: {
  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    pciutils
  ];

  virtualisation = {
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        ovmf.enable = true;
        swtpm.enable = true;
        runAsRoot = true;
      };
      onBoot = "ignore";
      onShutdown = "shutdown";
      extraConfig = ''
        uri_default = "qemu:///system"
      '';
    };
  };

  networking.firewall.trustedInterfaces = ["virbr0"];
  users.groups.libvirtd.members = ["${user}"];
}
