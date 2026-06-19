{ ... }:
{
  imports = [
    ../../modules/shared.nix
    ../../modules/services.nix
    ./hardware-configuration.nix
    ./machine.nix
  ];
}
