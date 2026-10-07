{ ... }:

{
  # hostName is set by mkHost in flake.nix from the host directory name.
  networking = {
    networkmanager.enable = false;
    wireless.iwd = {
      enable = true;
      settings.General.EnableNetworkConfiguration = true;
    };
    useNetworkd = true;
  };
}
