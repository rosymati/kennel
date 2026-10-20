{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    pcsx2
    protonup-qt
  ];
}
