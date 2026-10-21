{ lib, pkgs, ... }:

{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./networking.nix
    ./services.nix
    ./packages.nix
    ./niri.nix
    ./ironbar.nix
    ./awww.nix
  ];

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Europe/Rome";

  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "it";

  users.users.matilde = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "gamemode"
    ];
    shell = pkgs.zsh;
  };

  hjem.users = {
    matilde = {
      enable = true;
      directory = "/home/matilde";
      user = "matilde";

      xdg.config.files = {
        "git/config" = {
          generator = lib.generators.toGitINI;

          value = {
            user = {
              name = "Matilde Morrone";
              email = "contact@rosymati.com";
              signingkey = "8BCD8313AED05D32";
            };
            commit.gpgsign = true;
            init.defaultBranch = "main";
          };
        };
      };
    };
  };

  programs = {
    foot = {
      enable = true;
      enableZshIntegration = true;
    };

    nix-ld.enable = true;
    gamemode.enable = true;

    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-qt;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    steam = {
      enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };

    zsh = {
      enable = true;
      enableCompletion = true;

      ohMyZsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
          "git"
        ];
      };
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep 5 --keep-since 7d";
      };
      flake = "/home/matilde/projects/kennel";
    };

    obs-studio = {
      enable = true;

      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-vkcapture
        obs-pipewire-audio-capture
        obs-vaapi
        obs-gstreamer
      ];
    };

    nixcord =
      let
        enablePlugins =
          plugins:
          lib.mergeAttrsList (
            map (
              name:
              if builtins.isString name then
                { ${name}.enable = true; }
              else
                lib.mapAttrs (_: opts: opts // { enable = true; }) name
            ) plugins
          );
      in
      {
        enable = true;
        user = "matilde";

        discord.enable = false;

        legcord = {
          enable = true;
          equicord.enable = true;
          settings = {
            mods = [ "equicord" ];
            tray = true;
            hardwareAcceleration = true;
            doneSetup = true;
          };
        };

        config.plugins = enablePlugins [
          "userMessagesPronouns"
          "questify"
          "betterGifPicker"
          { musicRichPresence.apiKey = ""; }
        ];
      };
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    liberation_ttf
    nerd-fonts.symbols-only
    nerd-fonts.jetbrains-mono
  ];

  security.pki.caCertificateBlacklist = [
    "Comodo AAA Services root"
    "emSign ECC Root CA - G3"
  ];

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  environment = {
    localBinInPath = true;
    sessionVariables.NIXOS_OZONE_WL = "1";
  };

  nix.channel.enable = false;
  nix.optimise.automatic = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    extra-substituters = [
      "https://helix.cachix.org"
      "https://cache.numtide.com" # llm-agents
    ];
    extra-trusted-public-keys = [
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" # llm-agents
    ];
  };
}
