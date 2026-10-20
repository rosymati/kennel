{ ... }:

{
  # hostName is set by mkHost in flake.nix from the host directory name.
  networking = {
    # iwd only handles association (its EnableNetworkConfiguration defaults to
    # false); systemd-networkd + resolved handle addressing and DNS.
    wireless.iwd.enable = true;
    useNetworkd = true;
  };
}
