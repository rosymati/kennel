{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Garbage needed for other inputs
    flake-compat.url = "github:NixOS/flake-compat";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixcord = {
      url = "github:FlameFlag/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.treefmt-nix.follows = "treefmt-nix";
      inputs.home-manager.follows = "home-manager";
      inputs.nix-darwin.follows = "nix-darwin";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri-nix = {
      url = "git+https://codeberg.org/BANanaD3V/niri-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.treefmt-nix.follows = "treefmt-nix";
    };

    weston-demos = {
      url = "github:rosymati/weston-demos-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    obsbot-camera-control = {
      url = "git+file:///home/matilde/projects/obsbot-camera-control";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      ...
    }:
    let
      overlays = with inputs; {
        nixpkgs.overlays = [
          helix.overlays.default
          weston-demos.overlays.default

          (final: prev: llm-agents.packages.${prev.stdenv.hostPlatform.system} or { })

          (final: prev: {
            zen-browser = zen-browser.packages.${prev.stdenv.hostPlatform.system}.default;
          })
        ];
      };

      commonModules = with inputs; [
        overlays
        hjem.nixosModules.default
        chaotic.nixosModules.default
        nixcord.nixosModules.nixcord
      ];

      # Every directory under ./hosts is a host: it needs a
      # hardware-configuration.nix and a machine.nix. Host-only flake modules
      # (nixos-hardware, etc.) are imported from that host's machine.nix.
      mkHost =
        name:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./modules/shared.nix
            ./hosts/${name}/hardware-configuration.nix
            ./hosts/${name}/machine.nix
            { networking.hostName = name; }
          ]
          ++ commonModules;
        };

      hosts = builtins.attrNames (
        nixpkgs.lib.filterAttrs (_: type: type == "directory") (builtins.readDir ./hosts)
      );
    in
    {
      devShells = import ./modules/devshell.nix { inherit nixpkgs; };

      nixosConfigurations = nixpkgs.lib.genAttrs hosts mkHost;
    };
}
