# Placeholder — replace with output of: nixos-generate-config --root /mnt
{ lib, ... }:

{
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
