{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.modules.core.infra.mimes;
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
          "default-web-browser" = [ "firefox.desktop" ];
          "text/html" = [ "firefox.desktop" ];
          "x-scheme-handler/http" = [ "firefox.desktop" ];
          "x-scheme-handler/https" = [ "firefox.desktop" ];
          "x-scheme-handler/about" = [ "firefox.desktop" ];
          "x-scheme-handler/unknown" = [ "firefox.desktop" ];
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
