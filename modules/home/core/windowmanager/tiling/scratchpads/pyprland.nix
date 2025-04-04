{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.modules.core.windowmanager.tiling.scratchpads.pyprland;
in
{
  config = lib.mkIf module.enable {
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
      command = "alacritty --class=scratchpad.alacritty"
      class = "scratchpad.alacritty"
      size = "90% 90%"

      [scratchpads.spotify]
      animation = "fromBottom"
      hide_delay = 0.5
      command = "spotify --class scratchpad.spotify"
      class = "scratchpad.spotify"
      size = "80% 60%"

      [scratchpads.whatsapp]
      animation = "fromBottom"
      hide_delay = 0.5
      command = "zapzap"
      class = "com.rtosta.zapzap"
      size = "80% 80%"     

      [scratchpads.signal]
      animation = "fromBottom"
      hide_delay = 0.5
      command = "signal-desktop"
      class = "signal"
      size = "80% 80%"   
    '';
  };
}
