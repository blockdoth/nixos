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
    # https://raw.githubusercontent.com/refact0r/system24/refs/heads/main/theme/flavors/gruvbox-material.theme.css
    # # Simple CSS
    # home.file.".config/vesktop/settings/quickCss.css".text =
    # ''

    # '';

    # Failed attempt at making vencord settings reproducible
    # unfortenately it doesnt auto enable the theme, which means I would need to switch it on after each rebuild... not worth it
    # Vencord settings
    # home.file.".config/vesktop/settings/settings.json" = {
    #   source = ./vencord-config.json;
    # };

  };
}
