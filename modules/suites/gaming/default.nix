{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkDefault mkEnableOption mkIf;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.suites.gaming;
in {
  options.${namespace}.suites.gaming = {
    enable = mkEnableOption "Gaming configuration";
  };

  config = mkIf cfg.enable {
    # Some platform optimization that Steam Deck also uses
    boot.kernel.sysctl = {
      # 20-shed.conf
      "kernel.sched_cfs_bandwidth_slice_us" = 3000;
      # 20-net-timeout.conf
      # This is required due to some games being unable to reuse their TCP ports
      # if they're killed and restarted quickly - the default timeout is too large.
      "net.ipv4.tcp_fin_timeout" = 5;
      # 30-splitlock.conf
      # Prevents intentional slowdowns in case games experience split locks
      # This is valid for kernels v6.0+
      "kernel.split_lock_mitigate" = 0;
      # 30-vm.conf
      # USE MAX_INT - MAPCOUNT_ELF_CORE_MARGIN.
      # see comment in include/linux/mm.h in the kernel tree.
      "vm.max_map_count" = 2147483642;
    };

    snowflake = {
      programs = {
        graphical = {
          addons = {
            gamemode = mkDefault enabled;
            gamescope = mkDefault enabled;
            ntsync = mkDefault enabled;
          };
          apps = {
            steam = mkDefault enabled;
          };
        };
      };
    };
  };
}
