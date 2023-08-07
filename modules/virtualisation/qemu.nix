{config, pkgs, user, ... }:

{  
  boot.kernelParams = [ "amd_iommu=on" ];
  boot.kernelModules = [ "vfio" "vfio_iommu_type1" "vfio_pci" "vfio_virqfd" ];
  
  environment.systemPackages = with pkgs; [
    virt-manager
  ];
  
  virtualisation = {
    libvirtd = {
      enable = true;
    };
  };

  networking.firewall.trustedInterfaces = [ "virbr0" ];
  programs.dconf.enable = true;
  users.groups.libvirtd.members = [ "${user}" ];
}
