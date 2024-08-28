{ pkgs, config, lib, ... }:
{
  options = {
    modules.core.services.mediadeamon.mpd.enable = lib.mkEnableOption "Enables mpd";
  };

  config = lib.mkIf config.modules.core.services.mediadeamon.mpd.enable {
    home.packages = with pkgs; [
      mpc-cli
    ];

    services.mpd = {
      enable = true;
      musicDirectory = "/home/blockdoth/Music";
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
