{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.local.awww;

  rotate = pkgs.writeShellApplication {
    name = "awww-rotate";
    runtimeInputs = [
      pkgs.awww
      pkgs.findutils
      pkgs.coreutils
    ];
    text = ''
      dir=${lib.escapeShellArg "${cfg.directory}"}
      mapfile -t imgs < <(find -L "$dir" -type f \
        \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' -o -iname '*.gif' \) | sort)
      if [ ''${#imgs[@]} -eq 0 ]; then
        echo "awww-rotate: no wallpapers in $dir" >&2
        exit 1
      fi

      # wait until the daemon socket is ready
      until awww query >/dev/null 2>&1; do sleep 0.2; done

      ${
        if cfg.order == "random" then
          ''
            while true; do
              awww img "''${imgs[RANDOM % ''${#imgs[@]}]}"
              sleep ${cfg.interval}
            done
          ''
        else
          ''
            i=0
            while true; do
              awww img "''${imgs[i]}"
              i=$(( (i + 1) % ''${#imgs[@]} ))
              sleep ${cfg.interval}
            done
          ''
      }
    '';
  };
in
{
  options.local.awww = {
    directory = lib.mkOption {
      type = lib.types.path;
      default = ../wallpapers;
      description = "Directory to pick wallpapers from.";
    };
    interval = lib.mkOption {
      type = lib.types.str;
      default = "5m";
      description = "Time between wallpaper changes, in sleep(1) duration syntax.";
    };
    order = lib.mkOption {
      type = lib.types.enum [
        "random"
        "sequential"
      ];
      default = "random";
      description = "Whether to cycle wallpapers randomly or in filename order.";
    };
  };

  config = {
    systemd.user.services.awww-daemon = {
      description = "awww wallpaper daemon";
      wantedBy = [ "niri.service" ];
      after = [ "niri.service" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.awww}/bin/awww-daemon";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    systemd.user.services.awww-rotate = {
      description = "awww wallpaper rotation";
      wantedBy = [ "niri.service" ];
      after = [ "awww-daemon.service" ];
      requires = [ "awww-daemon.service" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = lib.getExe rotate;
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
