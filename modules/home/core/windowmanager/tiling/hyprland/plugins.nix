{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.modules.core.windowmanager.tiling.hyprland;
  plugins = inputs.hyprland-plugins.packages.${pkgs.system};
in
{
  config = lib.mkIf module.enable {
    wayland.windowManager.hyprland = {
      plugins = [
        plugins.hyprexpo
        plugins.hyprwinwrap
        plugins.hyprwinwrap
        inputs.hyprtasking.packages.${pkgs.system}.hyprtasking
        inputs.hypr-dynamic-cursors.packages.${pkgs.system}.hypr-dynamic-cursors
      ];
      settings = {
        plugins = {
          hyprtasking = {
            layout = "grid";

            gap_size = 20;
            bg_color = "0xff26233a";
            border_size = 4;
            exit_on_hovered = false;

            gestures = {
              enabled = true;
              move_fingers = 3;
              move_distance = 300;
              open_fingers = 4;
              open_distance = 300;
              open_positive = true;
            };

            grid = {
              rows = 3;
              cols = 3;
              loop = false;
              gaps_use_aspect_ratio = false;
            };

            linear = {
              height = 400;
              scroll_speed = 1.0;
              blur = false;
            };
          };

          hyprexpo = {
            columns = 3;
            gap_size = 5;
            bg_col = "rgb(111111)";
            workspace_method = "center current"; # [center/first] [workspace] e.g. first 1 or center m+1
          };

          # crashes hyprland in combination with prismlauncher for some reason
          hyprwinwrap = {
            class = "alacritty-bg";
          };
        };
      };
    };
  };
}
