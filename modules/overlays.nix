inputs: {
  nixpkgs.overlays = [
    inputs.nix-cachyos-kernel.overlays.pinned
    inputs.opencode.overlays.default
    inputs.helix.overlays.default
    (final: prev: {
      zen-browser = inputs.zen-browser.packages.${prev.system}.default;
      ironbar = inputs.ironbar.packages.${prev.system}.default;
    })
    inputs.bunbun.overlays.default
  ];

  imports = [ inputs.nixcord.nixosModules.nixcord ];
}
