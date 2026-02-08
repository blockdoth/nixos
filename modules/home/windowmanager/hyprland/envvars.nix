{
  config,
  lib,
  hostname,
  ...
}:
let
  module = config.modules.windowmanager.hyprland;
in
{
  config = lib.mkIf module.enable {
    home.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = 1;
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      NIXOS_OZONE_WL = 1;
      # TODO fix this with stylix
      XCURSOR_SIZE = 15;
      HYPRCURSOR_SIZE = 15;
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_SCREENSHOTS_DIR =
        if hostname == "laptop" then
          "$HOME/pictures/screenshots/laptop"
        else if hostname == "desktop" then
          "$HOME/pictures/screenshots/desktop"
        else
          "$HOME/pictures/screenshots";
    };
  };
}
