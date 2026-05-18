{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.local.ironbar;

  ironbarConfig = {
    position = "top";
    anchor_to_edges = true;
    height = 32;

    start = [
      { type = "workspaces"; }
    ];

    center = [
      {
        type = "clock";
        format = "%H:%M  %a %e %b";
      }
    ];

    end = [
      { type = "volume"; }
      { type = "tray"; }
    ]
    ++ cfg.extraEndWidgets;
  };

in
{
  options.local.ironbar = {
    extraEndWidgets = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = [ ];
      description = "Extra widgets appended to the end section of the bar.";
    };
  };

  config = {
    hjem.users.matilde.xdg.config.files."ironbar/config.toml" = {
      source = (pkgs.formats.toml { }).generate "config.toml" ironbarConfig;
    };
  };
}
