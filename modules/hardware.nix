{ ... }:

{
  # Kept out of the generated hardware-configuration.nix files so that
  # re-running nixos-generate-config doesn't drop them.
  hardware = {
    cpu.amd.updateMicrocode = true;
    enableAllFirmware = true;
    amdgpu.initrd.enable = true;
    # Also installs the ZSA udev rules (Oryx WebHID, Voyager flashing).
    keyboard.zsa.enable = true;
  };
}
