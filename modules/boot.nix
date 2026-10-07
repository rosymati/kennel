{ lib, pkgs, ... }:

{
  boot = {
    # Both current hosts are Zen 4+; override per-host for anything older.
    kernelPackages = lib.mkDefault pkgs.linuxPackages_cachyos-lto-znver4;

    blacklistedKernelModules = [ "ntfs3" ];

    tmp.cleanOnBoot = true;

    zswap = {
      enable = true;
      compressor = "zstd";
      zpool = "zsmalloc";
      maxPoolPercent = 20;
    };

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = false;

      limine = {
        enable = true;
        enableEditor = true;
        maxGenerations = 5;

        additionalFiles = {
          "memtest86/memtest.efi" = pkgs.memtest86plus.efi;
        };

        style.wallpapers = [ ];

        # Hosts can prepend their own entries (e.g. Windows) with lib.mkBefore.
        extraEntries = ''
          /Memtest86+
              protocol: efi
              path: boot():/limine/memtest86/memtest.efi
        '';
        extraConfig = ''
          remember_last_entry: yes
        '';
      };
    };
  };
}
