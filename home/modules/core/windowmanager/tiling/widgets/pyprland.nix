{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    modules.core.windowmanager.tiling.widgets.pyprland.enable = lib.mkEnableOption "Enables pyprland";
  };

  config = lib.mkIf config.modules.core.windowmanager.tiling.widgets.pyprland.enable {
    home.packages = with pkgs; [ pyprland ];

    home.file."/home/blockdoth/.config/hypr/pyprland.toml".text = ''
      [pyprland]
      plugins = [
       "magnify",
       "scratchpads",
      ]

      [scratchpads.term]
      animation = "fromBottom"
      hide_delay = 0.5
      command = "ghostty --class=scratchpad.alacritty -e \"fish -C fastfetch\""
      class = "scratchpad.alacritty"
      size = "90% 90%"

      [scratchpads.spotify]
      animation = "fromBottom"
      hide_delay = 0.5
      command = "spotify --class scratchpad.spotify"
      class = "scratchpad.spotify"
    '';
  };
}
