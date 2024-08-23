{ pkgs, config, lib, ... }:
{
  options = {
    windowmanager.wayland.widgets.pyprland.enable = lib.mkEnableOption "Enables hyprpaper";
  };

  config = lib.mkIf config.windowmanager.wayland.widgets.pyprland.enable {
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
      command = "alacritty --class scratchpad.alacritty"
      class = "scratchpad.alacritty"
      

      # [scratchpads.spotify]
      # animation = "fromBottom"
      # command = "spotify --class scratchpad.spotify"
      # class = "spotify"
      # size = "75% 60%"
    '';
  };
}
