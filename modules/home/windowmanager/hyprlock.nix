{
  config,
  lib,
  hostname,
  ...
}:
let
  module = config.modules.windowmanager.lockscreen.hyprlock;
in
{
  config = lib.mkIf module.enable {
    programs.hyprlock = {
      enable = true;

      settings = {
        general = {
          hide_cursor = true;
          ignore_empty_input = true;
          fail_timeout = 0;
        };

        background = [
          {
            path = "screenshot";
            color = "rgba(0, 0, 0, 0)";
            blur_passes = 2;
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
            placeholder_text = "";
            hide_input = false;
            position = "0, -200";
            halign = "center";
            valign = "center";
            monitor = if hostname == "laptop" then "eDP-1" else "DP-1";
          }
        ];

        label = [
          {
            text = "$TIME";
            color = "rgba(255, 255, 255, 0.6)";
            font_size = 350;
            font_family = "JetBrains Mono Ultra-Bold";
            position = "0, -200";
            halign = "center";
            valign = "top";
            monitor = if hostname == "laptop" then "eDP-1" else "DP-1";
          }
        ];
      };
    };
  };
}
