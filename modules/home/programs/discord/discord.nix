{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.modules.programs.discord;
in
{
  config = lib.mkIf module.enable {
    home.packages = with pkgs; [ vesktop ];

    # Vesktop settings
    home.file.".config/vesktop/settings.json".text = ''
      {
        "minimizeToTray": "on",
        "discordBranch": "stable",
        "arRPC": "on",
        "splashColor": "#${config.lib.stylix.colors.base02}",
        "splashBackground":  "#${config.lib.stylix.colors.base01}",
        "enableMenu": false,
        "tray": true,
        "openLinksWithElectron": false
      }
    '';
    # home.file.".config/vesktop/themese/system24".source = ./themes/systemd24.theme.css;
  };
}
