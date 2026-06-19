{ pkgs, ... }:

{
  imports = [ ./packages.nix ];

  networking = {
    hostName = "mati-nixing";
    networkmanager.enable = false;
    wireless.iwd = {
      enable = true;
      settings.General.EnableNetworkConfiguration = true;
    };
    useNetworkd = true;
  };

  hardware.amdgpu.initrd.enable = true;

  local.niri = {
    warpMouseToFocus = true;
    outputs = [
      {
        _args = [ "LG Electronics LG ULTRAGEAR+ 501NTLE7W704" ];
        mode = "3840x2160@240";
        scale = 1.5;
      }
      {
        _args = [ "Dell Inc. DELL AW2523HF 1NCHC34" ];
        mode = "1920x1080@360";
        scale = 1;
        transform = "270";
        layout."default-column-width"._children = [ { proportion = 1.0; } ];
      }
    ];
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos-lto-znver4;
    kernelParams = [
      "amdgpu.ppfeaturemask=0xffffffff"
    ];

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = false;

      limine = {
        enable = true;
        enableEditor = true;
        maxGenerations = 5;

        style = {
          wallpapers = [ ];
          interface.resolution = "1920x1080";
        };

        extraEntries = ''
          /Windows
              protocol: efi
              path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
        '';
        extraConfig = ''
          remember_last_entry: yes
        '';
      };
    };
  };

  services.lact.enable = true;
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
  };

  services.open-webui = {
    enable = true;
    port = 4543;
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  systemd.user.services.swaybg = {
    description = "swaybg wallpaper";
    wantedBy = [ "niri.service" ];
    after = [ "niri.service" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.swaybg}/bin/swaybg -o DP-2 -i %h/Pictures/wall-rotated.png -o '*' -i %h/Pictures/wall.png";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  system.stateVersion = "25.11";
}
