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
    # doest make the file for some reason and I dont know why
    home.file.".config/vesktop/themes/system24.theme.css".source = ./themes/system24.theme.css;

  };
}
