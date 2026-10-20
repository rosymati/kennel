{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.local.awww;

  next = pkgs.writeShellApplication {
    name = "awww-next";
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
        echo "awww-next: no wallpapers in $dir" >&2
        exit 1
      fi

      # wait until the daemon socket is ready
      until awww query >/dev/null 2>&1; do sleep 0.2; done

      export AWWW_TRANSITION_STEP=${toString cfg.transitionStep}

      ${
        if cfg.order == "random" then
          ''
            awww img "''${imgs[RANDOM % ''${#imgs[@]}]}"
          ''
        else
          ''
            state="''${XDG_RUNTIME_DIR:-/tmp}/awww-next.idx"
            i=0
            [ -f "$state" ] && i=$(cat "$state")
            i=$(( i % ''${#imgs[@]} ))
            awww img "''${imgs[i]}"
            echo $(( (i + 1) % ''${#imgs[@]} )) > "$state"
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
      description = "Time between wallpaper changes, as a systemd time span (e.g. 5m, 1h).";
    };
    order = lib.mkOption {
      type = lib.types.enum [
        "random"
        "sequential"
      ];
      default = "random";
      description = "Whether to cycle wallpapers randomly or in filename order.";
    };
    transitionStep = lib.mkOption {
      type = lib.types.ints.between 1 255;
      default = 7;
      description = ''
        awww transition step (1-255) for wallpaper changes. Higher is faster;
        awww's own default is 2. Passed via AWWW_TRANSITION_STEP.
      '';
    };
  };

  config = {
    # `awww-next` available as a manual trigger (command / keybind).
    environment.systemPackages = [ next ];

    local.sessionServices.awww-daemon = {
      description = "awww wallpaper daemon";
      command = "${pkgs.awww}/bin/awww-daemon";
    };

    # One wallpaper change per run; the timer fires once at session start and
    # then every `interval`.
    systemd.user.services.awww-rotate = {
      description = "awww wallpaper rotation";
      partOf = [ "graphical-session.target" ];
      after = [ "awww-daemon.service" ];
      requires = [ "awww-daemon.service" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = lib.getExe next;
        # awww-next waits for the daemon socket; don't let that hang forever.
        TimeoutStartSec = 30;
      };
    };

    systemd.user.timers.awww-rotate = {
      description = "awww wallpaper rotation";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      timerConfig = {
        OnActiveSec = 0;
        OnUnitActiveSec = cfg.interval;
        AccuracySec = "1s";
      };
    };
  };
}
