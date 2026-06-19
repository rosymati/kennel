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

  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos-lto-znver4;

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
