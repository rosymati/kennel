{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-compat = {
      url = "github:NixOS/flake-compat";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-parts.follows = "flake-parts";
    };

    nixcord = {
      url = "github:FlameFlag/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-parts.follows = "flake-parts";
    };

    opencode = {
      url = "github:anomalyco/opencode/v1.15.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    bunbun = {
      url = "github:puppymati/bunbun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # obsbot-camera-control = {
    #   url = "path:/home/matilde/projects/obsbot-camera-control";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixos-hardware,
      ...
    }:
    let
      overlaysModule = import ./modules/overlays.nix inputs;
      # desktopObsbotOverlay = {
      #   nixpkgs.overlays = [
      #     (final: prev: {
      #       obsbot-camera-control = inputs.obsbot-camera-control.packages.${prev.system}.obsbot-camera-control;
      #     })
      #   ];
      # };
    in
    {
      nixosConfigurations.mati-nixing = nixpkgs.lib.nixosSystem {
        modules = [
          overlaysModule
          # desktopObsbotOverlay
          ./hosts/mati-nixing/default.nix
        ];
      };

      nixosConfigurations.frameyboy = nixpkgs.lib.nixosSystem {
        modules = [
          overlaysModule
          nixos-hardware.nixosModules.framework-amd-ai-300-series
          ./hosts/frameyboy/default.nix
        ];
      };
    };
}
