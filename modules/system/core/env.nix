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
      etc."current-system-packages".text =
        let
          packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
          sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
          formatted = pkgs.lib.strings.concatLines sortedUnique;
        in
        formatted;
    };
  };
}
