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
          "x-scheme-handler/discord" = [ "vesktop.desktop" ];
        };
      };

      desktopEntries = {
        micro-terminal = {
          name = "Micro Terminal";
          exec = "alacritty -e micro %f";
          type = "Application";
          mimeType = [ "application/txt" ];
        };
        micro-terminal-json = {
          name = "Micro Terminal For Json";
          exec = "alacritty -e sh -c \"jq . \\\"%f\\\" | micro -\"";
          type = "Application";
          mimeType = [ "application/json" ];
        };
      };
    };
  };
}
