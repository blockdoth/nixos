{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.modules.core.windowmanager.tiling.mediadeamon.mpd;
in
{
  config = lib.mkIf module.enable {
    home.packages = with pkgs; [ mpc-cli ];
    services.mpd = {
      enable = true;
      # musicDirectory = "/home/blockdoth/Music";
      # user = "blockdoth";
      network.startWhenNeeded = false;
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "My PipeWire Output"
        }
      '';
    };
  };
}
