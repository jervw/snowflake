{config, pkgs, ... }:

{  
  boot.kernelParams = [ "amd_iommu=on" ];
  boot.kernelModules = [ "vfio" "vfio_iommu_type1" "vfio_pci" "vfio_virqfd" ];
  
  environment.systemPackages = with pkgs; [
    virt-manager
  ];
  
  virtualisation.libvirtd.enable = true;

  # Docker
  virtualisation.docker = {
    enable = true;
    enableNvidia = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
  
  # $ ls /nix/store/*OVMF*/FV/OVMF{,_VARS}.fd | tail -n2 | tr '\n' : | sed -e 's/:$//'
  # to find your nix store paths
  virtualisation.libvirtd.qemu.verbatimConfig = ''
    nvram = [
      "/nix/store/awlsfbjbiq46dgsam90ay5rjazyk47sx-OVMF-202211-fd/FV/OVMF.fd:/nix/store/awlsfbjbiq46dgsam90ay5rjazyk47sx-OVMF-202211-fd/FV/OVMF_VARS.fd"
    ]
  '';

}
