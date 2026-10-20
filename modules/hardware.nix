{ ... }:

{
  # Kept out of the generated hardware-configuration.nix files so that
  # re-running nixos-generate-config doesn't drop them.
  hardware = {
    # nixpkgs defaults this to false; nixos-generate-config normally emits it
    # but the ahnashawn hardware-configuration.nix lacks it.
    cpu.amd.updateMicrocode = true;
    amdgpu.initrd.enable = true;
    # Also installs the ZSA udev rules (Oryx WebHID, Voyager flashing).
    keyboard.zsa.enable = true;
  };
}
