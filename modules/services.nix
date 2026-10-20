{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Long-running user services tied to the graphical session. niri.service
  # binds graphical-session.target, so these start and stop with niri.
  options.local.sessionServices = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          description = lib.mkOption { type = lib.types.str; };
          command = lib.mkOption {
            type = lib.types.str;
            description = "ExecStart command line.";
          };
        };
      }
    );
    default = { };
    description = "User services started with, and stopped alongside, the graphical session.";
  };

  config = {
    services.displayManager.ly.enable = true;
    services.gnome.gnome-keyring.enable = true;
    services.udisks2.enable = true;
    services.tailscale.enable = true;
    services.resolved.enable = true;
    services.usbmuxd.enable = true;
    services.btrfs.autoScrub.enable = true;

    services.mullvad-vpn = {
      enable = true;
      gui.enable = true;
    };

    services.pipewire = {
      enable = true;
      pulse.enable = true;
      jack.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
    };

    local.sessionServices = {
      polkit-kde-authentication-agent-1 = {
        description = "KDE polkit authentication agent";
        command = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
      };
      udiskie = {
        description = "Automount removable media";
        command = "${lib.getExe pkgs.udiskie} --automount --no-file-manager";
      };
      ironbar = {
        description = "ironbar";
        command = lib.getExe pkgs.ironbar;
      };
    };

    systemd.user.services = lib.mapAttrs (_: svc: {
      inherit (svc) description;
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      # Not After=graphical-session.target: the target is implicitly ordered
      # after what it wants, so that would be a cycle. niri.service is
      # Type=notify and Before= the target, so this waits for a ready session.
      after = [ "niri.service" ];
      serviceConfig = {
        ExecStart = svc.command;
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    }) config.local.sessionServices;
  };
}
