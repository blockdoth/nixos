{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.modules.core.utils.mimes;
in
{
  config = lib.mkIf module.enable {
    xdg = {
      mimeApps = {
        enable = true;
        defaultApplications = {
          "application/zip" = [ "org.gnome.FileRoller.desktop" ];
          "application/json" = [ "micro-terminal-json.desktop" ];
          "application/txt" = [ "micro-terminal.desktop" ];
        };
      };

      desktopEntries = {
        micro-terminal = {
          name = "Micro Terminal";
          exec = "alacritty -e micro %f";
          terminal = true;
          type = "Application";
          mimeType = [ "application/txt" ];
        };
        micro-terminal-json = {
          name = "Micro Terminal For Json";
          exec = "alacritty -e sh -c \"jq . \\\"%f\\\" | micro -\"";
          terminal = true;
          type = "Application";
          mimeType = [ "application/json" ];
        };
      };
    };
  };
}
