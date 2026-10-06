{ pkgs, ... }:

{
  imports = [ ./packages.nix ];

  networking = {
    hostName = "ahnashawn";
    networkmanager.enable = false;
    wireless.iwd = {
      enable = true;
      settings.General.EnableNetworkConfiguration = true;
    };
    useNetworkd = true;
  };

  local.niri = {
    warpMouseToFocus = true;
    outputs = [
      {
        _args = [ "ASUSTek COMPUTER INC VY279HGR T6LMTF202856" ];
        mode = "1920x1080@120";
        scale = 1;
        position = {
          _props = {
            x = 0;
            y = 0;
          };
        };
        transform = "270";
        layout."default-column-width"._children = [ { proportion = 1.0; } ];
      }
      {
        _args = [ "LG Electronics LG ULTRAGEAR+ 501NTLE7W704" ];
        mode = "3840x2160@240";
        scale = 1.5;
        position = {
          _props = {
            x = 1080;
            y = 0;
          };
        };
      }
      {
        _args = [ "Dell Inc. DELL AW2523HF 1NCHC34" ];
        mode = "1920x1080@360";
        scale = 1;
      }
    ];
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
          interface.resolution = "1920x1080";
        };

        extraEntries = ''
          /Windows
              protocol: efi
              path: boot():/EFI/Microsoft/Boot/bootmgfw.efi

          /Memtest86+
              protocol: efi
              path: boot():/limine/memtest86/memtest.efi
        '';
        extraConfig = ''
          remember_last_entry: yes
        '';
      };
    };
  };

  services.lact.enable = false;
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
  };

  services.open-webui = {
    enable = true;
    port = 4543;
  };

  programs = {
    chromium.enable = true;

    gamescope = {
      enable = true;
      capSysNice = false;
    };

    obsbot-camera-control = {
      enable = true;
      # Loads v4l2loopback with the options the app expects (/dev/video42)
      virtualCamera.enable = false;
    };
  };

  system.stateVersion = "25.11";
}
