{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # obsbot-camera-control
    pcsx2
    protonup-qt
  ];
}
