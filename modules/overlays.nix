inputs: {
  nixpkgs.overlays = [
    inputs.nix-cachyos-kernel.overlays.pinned
    inputs.helix.overlays.default
    inputs.llm-agents.overlays.default
    (final: prev: {
      zen-browser = inputs.zen-browser.packages.${prev.system}.default;
      ironbar = inputs.ironbar.packages.${prev.system}.default;
    })
  ];

  imports = [ inputs.nixcord.nixosModules.nixcord ];
}
