{
  config,
  lib,
  ...
}:
let
  module = config.modules.windowmanager.hyprland;
in
{
  config = lib.mkIf module.enable {
    wayland.windowManager.hyprland.settings = {
      monitor = [
        "DP-1,2560x1440@143.972Hz,0x0,1"
        "DP-2,1920x1200@99.94Hz,2560x-310,1,transform,3"
        "eDP-1,preferred,0x0,1"
      ];

      workspace = [
        "1, monitor:DP-1, default:true"
        "2, monitor:DP-1"
        "3, monitor:DP-1"
        "4, monitor:DP-1"
        "5, monitor:DP-1"
        "6, monitor:DP-1"
        "7, monitor:DP-1"

        "11, monitor:DP-2, default:true"
        "12, monitor:DP-2"
        "13, monitor:DP-2"
        "14, monitor:DP-2"
        "15, monitor:DP-2"
        "16, monitor:DP-2"
        "17, monitor:DP-2"
      ];

      xwayland = {
        force_zero_scaling = true;
      };

      general = {
        gaps_in = 6;
        gaps_out = 6;
        border_size = 1;
        # "col.active_border" = lib.mkForce "rgba(${config.lib.stylix.colors.base0B}ee)";
        # "col.inactive_border" = "rgba(6A9FB5aa)";
        # apply_sens_to_raw = 1;
        layout = "dwindle";
        # snap = {
        #   enabled = true;
        # };
      };

      dwindle = {
        preserve_split = true;
      };

      decoration = {
        rounding = 5;

        shadow = {
          ignore_window = true;
          enabled = true;
          range = 8;
          render_power = 4;
          offset = "5 5";
        };
        blur = {
          enabled = true;
          size = 3;
          passes = 3;
          new_optimizations = true;
          ignore_opacity = true;
          noise = 1.17e-2;
          contrast = 1.3;
          brightness = 1;
          popups = true;
          xray = false;
        };
      };
    };
  };
}
