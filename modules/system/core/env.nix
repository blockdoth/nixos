{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  module = config.system-modules.core.networking;
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  config = lib.mkIf module.enable {
    environment.systemPackages = with pkgs; [
      home-manager
      micro
      git
      perf
    ];

    home-manager = {
      backupFileExtension = "backup";
      overwriteBackup = true;
    };

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
          packages = map (p: "${p.name}") config.environment.systemPackages;
          sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
          formatted = pkgs.lib.strings.concatLines sortedUnique;
        in
        formatted;
    };
  };
}
