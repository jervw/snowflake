{config, pkgs, ... }:
{  
  boot.kernelParams = [ "amd_iommu=on" ];
    
  # These modules are required for PCI passthrough, and must come before early modesetting stuff
  boot.kernelModules = [ "vfio" "vfio_iommu_type1" "vfio_pci" "vfio_virqfd" ];
  
  # CHANGE: Don't forget to put your own PCI IDs here
  #boot.extraModprobeConfig ="options vfio-pci ids=1002:67b1,1002:aac8";
  
  environment.systemPackages = with pkgs; [
    virt-manager
  ];
  
  virtualisation.libvirtd.enable = true;
  
  # CHANGE: use 
  #     ls /nix/store/*OVMF*/FV/OVMF{,_VARS}.fd | tail -n2 | tr '\n' : | sed -e 's/:$//'
  # to find your nix store paths
  virtualisation.libvirtd.qemu.verbatimConfig = ''
    nvram = [
      "/nix/store/awlsfbjbiq46dgsam90ay5rjazyk47sx-OVMF-202211-fd/FV/OVMF.fd:/nix/store/awlsfbjbiq46dgsam90ay5rjazyk47sx-OVMF-202211-fd/FV/OVMF_VARS.fd"
    ]
  '';

}
