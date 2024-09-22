{ pkgs, config, lib, ... }:
{
  options = {
   modules.core.windowmanager.tiling.widgets.pyprland.enable = lib.mkEnableOption "Enables hyprpaper";
  };

  config = lib.mkIf config.modules.core.windowmanager.tiling.widgets.pyprland.enable {
    home.packages = with pkgs; [
      pyprland
    ];


    home.file."/home/blockdoth/.config/hypr/pyprland.toml".text = ''
      [pyprland]
      plugins = [
      #  "expose", # broken
       "magnify",
       "scratchpads",
      ]

      [scratchpads.term]
      animation = "fromBottom"
      hide_delay = 0.5
      command = "alacritty --class scratchpad.alacritty"
      class = "scratchpad.alacritty"
      size = "90% 90%"
      # lazy = "true"
      

      [scratchpads.spotify]
      animation = "fromBottom"
      hide_delay = 0.5
      command = "spotify --class scratchpad.spotify"
      class = "scratchpad.spotify"
      # lazy = "true"
    '';
  };
}
