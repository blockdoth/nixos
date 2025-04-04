{
  pkgs,
  config,
  lib,
  hostname,
  ...
}:
let
  module = config.modules.core.infra.home-structure;
in
{
  config = lib.mkIf module.enable {
    home.sessionVariables = {
      XDG_SCREENSHOTS_DIR =
        if hostname == "laptop" then
          "$HOME/pictures/screenshots/laptop"
        else if hostname == "desktop" then
          "$HOME/pictures/screenshots/desktop"
        else
          "$HOME/pictures/screenshots";
      XDG_DESKTOP_DIR = "$HOME/desktop";
      XDG_DOCUMENTS_DIR = "$HOME/documents";
      XDG_DOWNLOAD_DIR = "$HOME/downloads";
      XDG_MUSIC_DIR = "$HOME/music";
      XDG_PICTURES_DIR = "$HOME/pictures";
      XDG_VIDEOS_DIR = "$HOME/videos";
    };

    systemd.user.services.setup-home-dir = {
      Unit = {
        Description = "Sets up the home dir ";
      };
      Install = {
        WantedBy = [ "multi-user.target" ];
      };
      Service = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writeShellScript "setup-home-dir" ''
          mkdir -p "$HOME/desktop"
          mkdir -p "$HOME/documents"
          mkdir -p "$HOME/downloads"
          mkdir -p "$HOME/music"
          mkdir -p "$HOME/pictures"
          mkdir -p "$HOME/videos"

          # Ensure hostname-specific screenshot directories
          HOSTNAME=$(hostname)
          if [ "$HOSTNAME" = "laptop" ]; then
            mkdir -p "$HOME/pictures/screenshots/laptop"
          elif [ "$HOSTNAME" = "desktop" ]; then
            mkdir -p "$HOME/pictures/screenshots/desktop"
          else
            mkdir -p "$HOME/pictures/screenshots"
          fi

          find "$HOME" -maxdepth 1 -type d -name '[A-Z]*' -exec basename {} \; > "$HOME/.hidden"
        '';
      };
    };
  };
}
