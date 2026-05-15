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

  boot = {
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-zen4;
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

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.obs-studio = {
    enable = true;

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-vkcapture
      obs-pipewire-audio-capture
      obs-vaapi
      obs-gstreamer
    ];
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
