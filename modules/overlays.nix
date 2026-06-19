inputs: with inputs; {
  nixpkgs.overlays = [
    helix.overlays.default
    llm-agents.overlays.default
    weston-demos.overlays.default
    (final: prev: {
      zen-browser = zen-browser.packages.${prev.system}.default;
      ironbar = ironbar.packages.${prev.system}.default;
    })
  ];

  imports = [ nixcord.nixosModules.nixcord ];
}
