{ config, lib, ... }:
{
  config = lib.mkIf config.modules.core.windowmanager.tiling.hyprland.enable {    
    wayland.windowManager.hyprland.settings = {
      monitor = [
          "DP-2,2560x1440@143.972Hz,0x0,1"
          "eDP-1,preferred,0x0,1.332031"
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
        apply_sens_to_raw = 1; 
        layout = "dwindle";
      };
      
      dwindle = {
        preserve_split = true;
      };
      
      decoration = {
        rounding = 5;
        shadow_ignore_window = true;
        drop_shadow = true;
        shadow_range = 8;
        shadow_render_power = 4;
        shadow_offset = "5 5";
        "col.shadow" = lib.mkForce "rgba(000000AA)";
        blur = {
          enabled = true;
          size = 3;
          passes = 3;
          new_optimizations = true;
          ignore_opacity = true;
          noise = 0.0117;
          contrast = 1.3;
          brightness = 1;
          popups = true;
          # xray = true;
        };
      };
    };
  };
}
