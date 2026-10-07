{ inputs, ... }:

{
  # Also enables power-profiles-daemon and amdgpu initrd.
  imports = [ inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series ];

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

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  system.stateVersion = "25.11";
}
