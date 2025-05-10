{
  config,
  lib,
  pkgs,
  ...
}:
let
  module = config.system-modules.core.networking;
in
{
  config = lib.mkIf module.enable {
    environment.systemPackages = with pkgs; [
      home-manager
      micro
      git
    ];

    environment = {
      variables = {
        EDITOR = "micro";
      };
      sessionVariables = lib.mkForce {
        XDG_CACHE_HOME = "$HOME/.cache";
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_DATA_DIRS = "/usr/local/share/:/usr/share/";
        XDG_DATA_HOME = "$HOME/.local/share";
        XDG_STATE_HOME = "$HOME/.local/state";
      };
    };
  };
}
