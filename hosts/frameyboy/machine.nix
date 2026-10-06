{ pkgs, ... }:

{
  local.ironbar.extraEndWidgets = [ { type = "battery"; } ];

  local.niri = {
    focusFollowsMouseMaxScrollAmount = "0%";
    focusRingWidth = 2;
    outputs = [
      {
        _args = [ "eDP-1" ];
        scale = 1.75;
      }
      {
        _args = [ "LG Electronics LG ULTRAGEAR+ 503NTBK7F333" ];
        mode = "3840x2160@240";
      }
    ];
  };

  networking = {
    hostName = "frameyboy";
    networkmanager.enable = false;
    wireless.iwd = {
      enable = true;
      settings.General.EnableNetworkConfiguration = true;
    };
    useNetworkd = true;
  };

  hardware.amdgpu.initrd.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos-lto-znver4;

    blacklistedKernelModules = [ "ntfs3" ];

    tmp.cleanOnBoot = true;

    zswap = {
      enable = true;
      compressor = "zstd";
      zpool = "zsmalloc";
      maxPoolPercent = 20;
    };

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = false;

      limine = {
        enable = true;
        enableEditor = true;
        maxGenerations = 5;

        additionalFiles = {
          "memtest86/memtest.efi" = pkgs.memtest86plus.efi;
        };

        style = {
          wallpapers = [ ];
          # interface.resolution = "1920x1080";
        };

        extraConfig = ''
          remember_last_entry: yes
        '';
      };
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/6ecbb696-1a2c-4fb5-9d45-ef5e8379e594"; }
  ];

  services.power-profiles-daemon.enable = true;

  system.stateVersion = "25.11";
}
