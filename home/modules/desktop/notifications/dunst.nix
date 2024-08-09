{ pkgs, config, lib, ... }:
{
  options = {
    notifications.dunst.enable = lib.mkEnableOption "Enables dunst";
  };

  config = lib.mkIf config.notifications.dunst.enable {
    home.packages = with pkgs; [
      libnotify
    ];

    services.dunst = {
      enable = true;
      iconTheme = {
        name = "Moka";
        package = pkgs.moka-icon-theme;
      };
      settings = {
        global = {
          origin = "top-center";
          monitor = "0";
          alignment = "center";
          vertical_alignment = "center";
          width = "400";
          height = "400";
          scale = 0;
          gap_size = 0;
          progress_bar = true;
          transparency = 0;
          text_icon_padding = 0;
          separator_color = "frame";
          sort = "yes";
          idle_threshold = 120;
          line_height = 0;
          markup = "full";
          show_age_threshold = 60;
          ellipsize = "middle";
          ignore_newline = "no";
          stack_duplicates = true;
          sticky_history = "yes";
          history_length = 20;
          always_run_script = true;
          follow = "mouse";
          corner_radius = 5;
          # font = config.var.theme.font;
          format = "<b>%s</b>\\n%b";
          progress_bar_corner_radius = 10;
          frame_width = 1;
          offset = "0x10";
          horizontal_padding = 10;
          icon_position = "left";
          indicate_hidden = "yes";
          min_icon_size = 0;
          max_icon_size = 64;
          mouse_left_click = "do_action, close_current";
          mouse_middle_click = "close_current";
          mouse_right_click = "close_all";
          padding = 10;
          separator_height = 2;
          show_indicators = "yes";
          shrink = "no";
          word_wrap = "yes";
        };

        fullscreen_delay_everything = { 
          fullscreen = "delay";
        };

        urgency_low = {
          background = "#141c21";
          foreground = "#93a1a1";
          frame_color = "#036b32";
        };
        urgency_normal = {
          background = "#141c21";
          foreground = "#93a1a1";
          frame_color = "#26397D";
        };
        urgency_critical = {
          background = "#141c21";
          foreground = "#93a1a1";
          frame_color = "#bf021e";
        };
      };
    };
  };
}
    
