{
  pkgs,
  user,
  ...
}: {
  environment.systemPackages = with pkgs; [
    virt-manager
    pciutils
  ];

  hardware.opengl.enable = true;

  virtualisation = {
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        ovmf.enable = true;
        swtpm.enable = true;
        runAsRoot = true;
        ovmf.packages = [
          ((pkgs.OVMFFull.override
            {
              secureBoot = true;
              tpmSupport = true;
              csmSupport = true;
              httpSupport = true;
            })
          .fd)
        ];
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
