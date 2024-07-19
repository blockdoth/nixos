{ pkgs, config, lib, ... }:
{
  options = {
    compositor.wayland.lockscreen.hyprlock.enable = lib.mkEnableOption "Enables hyprlock";
  };

  config = lib.mkIf config.compositor.wayland.lockscreen.hyprlock.enable {
    programs.hyprlock = {
      enable = true;

      settings = {
        general = {
          no_fade_in = false;
          grace = 0;
          disable_loading_bar = true;
        };

        background = [
          {
            path = "${../../../../../assets/wallpapers/basicblue.png}";
            blur_passes = 3;
            contrast = 0.8916;
            brightness = 0.8172;
            vibrancy = 0.1696;
            vibrancy_darkness = 0.0;
          }
        ];

        input-field = [
          {
            size = "2000, 200";
            outline_thickness = 0;
            dots_size = 0.4;
            dots_spacing = 0.5; 
            dots_center = true;
            outer_color = "rgba(0, 0, 0, 0)";
            inner_color = "rgba(0, 0, 0, 0)";
            check_color = "rgba(0, 0, 0, 0)";
            fail_color = "rgba(0, 0, 0, 0)";
            font_color = "rgb(200, 200, 200)";
            fade_on_empty = true;
            # font_family = "JetBrains Mono Nerd Font Mono";
            placeholder_text = "";
            hide_input = false;
            position = "0, -200";
            halign = "center";
            valign = "center";
          }
        ];

        label = [
          # TIME
          {
            text = "cmd[update:1000] echo \"$(date +\"%-I:%M%p\")\"";
            # color = "#cdd6f4";
            color = "rgba(255, 255, 255, 0.6)";
            font_size = 600;
            font_family = "JetBrains Mono Nerd Font Mono ExtraBold";
            position = "0, 0";
            halign = "center";
            valign = "top";
          }

          # # USER
          # {
          #   text = "cmd[update:1000] echo \"$USER\"";
          #   # color = "#cdd6f4";
          #   color = "rgba(255, 255, 255, 0.6)";
          #   font_size = 18;
          #   font_family = "JetBrains Mono Nerd Font Mono";
          #   position = "0, -120";
          #   halign = "center";
          #   valign = "center";
          # }
        ];
      };
    };
  };

  
  
}