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
        # plugins.hyprexpo
        # plugins.hyprwinwrap
      ];
      settings = {
        plugins = {
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
