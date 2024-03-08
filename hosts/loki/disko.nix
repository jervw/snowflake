{
  device ? throw "Set this to your disk device, e.g. /dev/sda",
  ...
}: {
  disko.devices = {
    disk.main = {
      inherit device;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          esp = {
            name = "ESP";
            size = "1024M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          luks = {
            size = "100%";
            content = {
              name = "crypted";
              type = "luks";
              extraOpenArgs = [];
              settings.allowDiscards = true;
              content = {            
                type = "lvm_pv";
                vg = "pool";
              };
            };
          };
        };
      };
    };
    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "100%FREE";
            content = {
              type = "btrfs";
              extraArgs = ["-f"];

              subvolumes = {
                "/root" = {
                  mountpoint = "/";
                };

                "/persist" = {
                  mountOptions = ["discard" "subvol=persist" "noatime" "compress=zstd"];
                  mountpoint = "/persist";
                };

                "/nix" = {
                  mountOptions = ["discard" "subvol=nix" "noatime" "compress=zstd"];
                  mountpoint = "/nix";
                };
              };
            };
          };
        };
      };
    };
  };
}
