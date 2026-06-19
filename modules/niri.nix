{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  inherit (inputs.niri-nix.lib) mkNiriKDL validatedConfigFor;
  cfg = config.local.niri;

  niriConfig = {

    input = {
      keyboard = {
        xkb.layout = "it";
        numlock = { };
      };
      touchpad = {
        tap = { };
        "natural-scroll" = { };
      };
    }
    // lib.optionalAttrs cfg.warpMouseToFocus {
      "warp-mouse-to-focus" = { };
    }
    // (
      if cfg.focusFollowsMouseMaxScrollAmount != null then
        {
          "focus-follows-mouse" = {
            _props."max-scroll-amount" = cfg.focusFollowsMouseMaxScrollAmount;
          };
        }
      else
        {
          "focus-follows-mouse" = { };
        }
    );

    output = cfg.outputs;

    layout = {
      gaps = 4;
    }
    // lib.optionalAttrs (cfg.focusRingWidth != 4) {
      # 4 is niri's built-in default; only emit the block when overriding it
      "focus-ring" = {
        width = cfg.focusRingWidth;
      };
    };

    "prefer-no-csd" = { };

    "window-rule" = [
      {
        match = {
          _props."app-id"._raw = ''r#"^org\.wezfurlong\.wezterm$"#'';
        };
        "default-column-width" = { };
      }
      {
        match = {
          _props = {
            "app-id"._raw = ''r#"firefox$"#'';
            title = "^Picture-in-Picture$";
          };
        };
        "open-floating" = true;
      }
    ];

    binds = {
      "Mod+Shift+Slash"."show-hotkey-overlay" = { };

      "Mod+Return" = {
        _props."hotkey-overlay-title" = "Open a Terminal: foot";
        spawn._args = [ "foot" ];
      };
      "Mod+D" = {
        _props."hotkey-overlay-title" = "Run an Application: fuzzel";
        spawn._args = [ "fuzzel" ];
      };
      "Super+Alt+L" = {
        _props."hotkey-overlay-title" = "Lock the Screen: swaylock";
        spawn._args = [ "swaylock" ];
      };
      "Super+Alt+S" = {
        _props = {
          "allow-when-locked" = true;
          "hotkey-overlay-title" = null;
        };
        "spawn-sh"._args = [ "pkill orca || exec orca" ];
      };

      "XF86AudioRaiseVolume" = {
        _props."allow-when-locked" = true;
        "spawn-sh"._args = [ "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0" ];
      };
      "XF86AudioLowerVolume" = {
        _props."allow-when-locked" = true;
        "spawn-sh"._args = [ "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-" ];
      };
      "XF86AudioMute" = {
        _props."allow-when-locked" = true;
        "spawn-sh"._args = [ "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle" ];
      };
      "XF86AudioMicMute" = {
        _props."allow-when-locked" = true;
        "spawn-sh"._args = [ "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle" ];
      };

      "XF86AudioPlay" = {
        _props."allow-when-locked" = true;
        "spawn-sh"._args = [ "playerctl play-pause" ];
      };
      "XF86AudioStop" = {
        _props."allow-when-locked" = true;
        "spawn-sh"._args = [ "playerctl stop" ];
      };
      "XF86AudioPrev" = {
        _props."allow-when-locked" = true;
        "spawn-sh"._args = [ "playerctl previous" ];
      };
      "XF86AudioNext" = {
        _props."allow-when-locked" = true;
        "spawn-sh"._args = [ "playerctl next" ];
      };

      "XF86MonBrightnessUp" = {
        _props."allow-when-locked" = true;
        spawn._args = [
          "brightnessctl"
          "--class=backlight"
          "set"
          "+10%"
        ];
      };
      "XF86MonBrightnessDown" = {
        _props."allow-when-locked" = true;
        spawn._args = [
          "brightnessctl"
          "--class=backlight"
          "set"
          "10%-"
        ];
      };

      "Mod+Shift+W" = {
        _props.repeat = false;
        _props."hotkey-overlay-title" = "Change Wallpaper: awww-next";
        spawn._args = [ "awww-next" ];
      };

      "Mod+O" = {
        _props.repeat = false;
        "toggle-overview" = { };
      };
      "Mod+Shift+Q" = {
        _props.repeat = false;
        "close-window" = { };
      };

      "Mod+Left"."focus-column-left" = { };
      "Mod+Down"."focus-window-down" = { };
      "Mod+Up"."focus-window-up" = { };
      "Mod+Right"."focus-column-right" = { };
      "Mod+H"."focus-column-left" = { };
      "Mod+J"."focus-window-down" = { };
      "Mod+K"."focus-window-up" = { };
      "Mod+L"."focus-column-right" = { };

      "Mod+Ctrl+Left"."move-column-left" = { };
      "Mod+Ctrl+Down"."move-window-down" = { };
      "Mod+Ctrl+Up"."move-window-up" = { };
      "Mod+Ctrl+Right"."move-column-right" = { };
      "Mod+Ctrl+H"."move-column-left" = { };
      "Mod+Ctrl+J"."move-window-down" = { };
      "Mod+Ctrl+K"."move-window-up" = { };
      "Mod+Ctrl+L"."move-column-right" = { };

      "Mod+Home"."focus-column-first" = { };
      "Mod+End"."focus-column-last" = { };
      "Mod+Ctrl+Home"."move-column-to-first" = { };
      "Mod+Ctrl+End"."move-column-to-last" = { };

      "Mod+Shift+Left"."focus-monitor-left" = { };
      "Mod+Shift+Down"."focus-monitor-down" = { };
      "Mod+Shift+Up"."focus-monitor-up" = { };
      "Mod+Shift+Right"."focus-monitor-right" = { };
      "Mod+Shift+H"."focus-monitor-left" = { };
      "Mod+Shift+J"."focus-monitor-down" = { };
      "Mod+Shift+K"."focus-monitor-up" = { };
      "Mod+Shift+L"."focus-monitor-right" = { };

      "Mod+Shift+Ctrl+Left"."move-column-to-monitor-left" = { };
      "Mod+Shift+Ctrl+Down"."move-column-to-monitor-down" = { };
      "Mod+Shift+Ctrl+Up"."move-column-to-monitor-up" = { };
      "Mod+Shift+Ctrl+Right"."move-column-to-monitor-right" = { };
      "Mod+Shift+Ctrl+H"."move-column-to-monitor-left" = { };
      "Mod+Shift+Ctrl+J"."move-column-to-monitor-down" = { };
      "Mod+Shift+Ctrl+K"."move-column-to-monitor-up" = { };
      "Mod+Shift+Ctrl+L"."move-column-to-monitor-right" = { };

      "Mod+Page_Down"."focus-workspace-down" = { };
      "Mod+Page_Up"."focus-workspace-up" = { };
      "Mod+U"."focus-workspace-down" = { };
      "Mod+I"."focus-workspace-up" = { };
      "Mod+Ctrl+Page_Down"."move-column-to-workspace-down" = { };
      "Mod+Ctrl+Page_Up"."move-column-to-workspace-up" = { };
      "Mod+Ctrl+U"."move-column-to-workspace-down" = { };
      "Mod+Ctrl+I"."move-column-to-workspace-up" = { };

      "Mod+Shift+Page_Down"."move-workspace-down" = { };
      "Mod+Shift+Page_Up"."move-workspace-up" = { };
      "Mod+Shift+U"."move-workspace-down" = { };
      "Mod+Shift+I"."move-workspace-up" = { };

      "Mod+WheelScrollDown" = {
        _props."cooldown-ms" = 150;
        "focus-workspace-down" = { };
      };
      "Mod+WheelScrollUp" = {
        _props."cooldown-ms" = 150;
        "focus-workspace-up" = { };
      };
      "Mod+Ctrl+WheelScrollDown" = {
        _props."cooldown-ms" = 150;
        "move-column-to-workspace-down" = { };
      };
      "Mod+Ctrl+WheelScrollUp" = {
        _props."cooldown-ms" = 150;
        "move-column-to-workspace-up" = { };
      };

      "Mod+WheelScrollRight"."focus-column-right" = { };
      "Mod+WheelScrollLeft"."focus-column-left" = { };
      "Mod+Ctrl+WheelScrollRight"."move-column-right" = { };
      "Mod+Ctrl+WheelScrollLeft"."move-column-left" = { };

      "Mod+Shift+WheelScrollDown"."focus-column-right" = { };
      "Mod+Shift+WheelScrollUp"."focus-column-left" = { };
      "Mod+Ctrl+Shift+WheelScrollDown"."move-column-right" = { };
      "Mod+Ctrl+Shift+WheelScrollUp"."move-column-left" = { };

      "Mod+BracketLeft"."consume-or-expel-window-left" = { };
      "Mod+BracketRight"."consume-or-expel-window-right" = { };
      "Mod+Comma"."consume-window-into-column" = { };
      "Mod+Period"."expel-window-from-column" = { };

      "Mod+R"."switch-preset-column-width" = { };
      "Mod+Shift+R"."switch-preset-window-height" = { };
      "Mod+Ctrl+R"."reset-window-height" = { };
      "Mod+F"."maximize-column" = { };
      "Mod+Shift+F"."fullscreen-window" = { };
      "Mod+Ctrl+F"."expand-column-to-available-width" = { };
      "Mod+C"."center-column" = { };
      "Mod+Ctrl+C"."center-visible-columns" = { };

      "Mod+Minus" = {
        "set-column-width"._args = [ "-10%" ];
      };
      "Mod+Equal" = {
        "set-column-width"._args = [ "+10%" ];
      };
      "Mod+Shift+Minus" = {
        "set-window-height"._args = [ "-10%" ];
      };
      "Mod+Shift+Equal" = {
        "set-window-height"._args = [ "+10%" ];
      };

      "Mod+V"."toggle-window-floating" = { };
      "Mod+Shift+V"."switch-focus-between-floating-and-tiling" = { };
      "Mod+W"."toggle-column-tabbed-display" = { };

      "Print"."screenshot" = { };
      "Ctrl+Print"."screenshot-screen" = { };
      "Alt+Print"."screenshot-window" = { };

      "Mod+Escape" = {
        _props."allow-inhibiting" = false;
        "toggle-keyboard-shortcuts-inhibit" = { };
      };
      "Mod+Shift+E"."quit" = { };
      "Ctrl+Alt+Delete"."quit" = { };
      "Mod+Shift+P"."power-off-monitors" = { };
    }
    // lib.listToAttrs (
      lib.genList (
        i:
        let
          n = i + 1;
        in
        {
          name = "Mod+${toString n}";
          value = {
            "focus-workspace"._args = [ n ];
          };
        }
      ) 9
    )
    // lib.listToAttrs (
      lib.genList (
        i:
        let
          n = i + 1;
        in
        {
          name = "Mod+Ctrl+${toString n}";
          value = {
            "move-column-to-workspace"._args = [ n ];
          };
        }
      ) 9
    );

  };

  builtConfig = validatedConfigFor pkgs.niri (mkNiriKDL niriConfig);

in
{
  imports = [ inputs.niri-nix.nixosModules.default ];

  options.local.niri = {
    outputs = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      description = "Per-host monitor output configurations.";
      example = [
        {
          _args = [ "eDP-1" ];
          scale = 1.75;
        }
      ];
    };
    warpMouseToFocus = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Warp mouse to center of newly focused windows.";
    };
    focusFollowsMouseMaxScrollAmount = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "If non-null, sets max-scroll-amount on focus-follows-mouse.";
    };
    focusRingWidth = lib.mkOption {
      type = lib.types.int;
      default = 4;
      description = "Focus ring width in logical pixels. Niri default is 4.";
    };
  };

  config = {
    programs.niri.enable = true;
    hjem.users.matilde.xdg.config.files."niri/config.kdl".source = builtConfig;
  };
}
