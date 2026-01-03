{
  config,
  lib,
  ...
}:
let
  module = config.modules.core.mimes;
in
{
  config = lib.mkIf module.enable {
    xdg = {
      mimeApps = {
        enable = true;
        defaultApplications = {
          "application/json" = [ "micro-terminal-json.desktop" ];
          "application/txt" = [ "micro-terminal.desktop" ];
          "application/xml" = [ "micro-terminal.desktop" ];
          "application/pdf" = [ "org.pwmt.zathura.desktop" ];
          "text/plain" = [ "micro-terminal.desktop" ];
          "text/csv" = [ "micro-terminal.desktop" ];
          "text/html" = [ "micro-terminal.desktop" ];
          "image/png" = [ "qimgv.desktop" ];
          "image/jpeg" = [ "qimgv.desktop" ];
          "image/bmp" = [ "qimgv.desktop" ];
          "image/webp" = [ "qimgv.desktop" ];
          "image/gif" = [ "qimgv.desktop" ];
          "video/mp4" = [ "vlc.desktop" ];
          "default-web-browser" = [ "zen-beta.desktop" ];
          "x-scheme-handler/discord" = [ "vesktop.desktop" ];
          "x-scheme-handler/spotify" = [ "spotify.desktop" ];
          "x-scheme-handler/http" = [ "zen-beta.desktop" ];
          "x-scheme-handler/https" = [ "zen-beta.desktop" ];
          # "inode/directory" = [ "thunar.desktop" ];
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
          exec = "alacritty -e sh -c \"jq . %f | micro \"";
          type = "Application";
          mimeType = [ "application/json" ];
        };
      };
    };
  };
}
