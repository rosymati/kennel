{
  inputs,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    inputs.obsbot-camera-control.nixosModules.default
    ./packages.nix
  ];

  local.niri = {
    warpMouseToFocus = true;
    outputs = [
      {
        _args = [ "ASUSTek COMPUTER INC VY279HGR T6LMTF202856" ];
        mode = "1920x1080@120";
        scale = 1;
        position = {
          _props = {
            x = 0;
            y = 0;
          };
        };
        transform = "270";
        layout."default-column-width"._children = [ { proportion = 1.0; } ];
      }
      {
        _args = [ "LG Electronics LG ULTRAGEAR+ 501NTLE7W704" ];
        mode = "3840x2160@240";
        scale = 1.5;
        position = {
          _props = {
            x = 1080;
            y = 0;
          };
        };
      }
      {
        _args = [ "Dell Inc. DELL AW2523HF 1NCHC34" ];
        mode = "1920x1080@360";
        scale = 1;
      }
    ];
  };

  boot.loader.limine = {
    style.interface.resolution = "1920x1080";

    extraEntries = lib.mkBefore ''
      /Windows
          protocol: efi
          path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
    '';
  };

  services.lact.enable = false;
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
  };

  services.open-webui = {
    enable = true;
    port = 4543;
  };

  programs = {
    gamescope = {
      enable = true;
      capSysNice = false;
    };

    obsbot-camera-control = {
      enable = true;
      # Loads v4l2loopback with the options the app expects (/dev/video42)
      virtualCamera.enable = false;
    };
  };

  system.stateVersion = "25.11";
}
