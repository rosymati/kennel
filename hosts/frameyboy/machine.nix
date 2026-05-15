{ pkgs, ... }:

{
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

  boot = {
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-zen4;

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = false;

      limine = {
        enable = true;
        enableEditor = true;
        maxGenerations = 5;
      };
    };
  };

  services.power-profiles-daemon.enable = true;

  systemd.user.services.swaybg = {
    description = "swaybg wallpaper";
    wantedBy = [ "niri.service" ];
    after = [ "niri.service" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.swaybg}/bin/swaybg -o '*' -i %h/Pictures/wall.png";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  system.stateVersion = "25.11";
}
