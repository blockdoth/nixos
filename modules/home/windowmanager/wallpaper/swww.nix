{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.modules.windowmanager.wallpaper.swww;
  wallpaperBasePath = "${../../../../assets/wallpapers}";
  wallpaperchanger = pkgs.writeShellScriptBin "wallpaperchanger" ''

    while true; do
        # List files in the wallpaper directory and send them to wofi
       SELECTED=$(ls "${wallpaperBasePath}"/*.{png,jpg,jpeg,gif,webp} 2>/dev/null | xargs -n 1 basename |  rofi -dmenu -p "" -theme-str '#window { width: 300px; }' -window-title "Select a wallpaper")

        # Check if a selection was made
        if [ -n "$SELECTED" ]; then
            # Set the selected wallpaper using swww
            swww img --transition-fps 144 --transition-type grow --transition-duration 2 --invert-y --transition-pos 0,0 "${wallpaperBasePath}/$SELECTED"
            break
        else
            # Exit the loop if no selection is made (e.g., user closes wofi or presses ESC)
           break
      fi
    done
  '';
in
{
  config = lib.mkIf module.enable {
    home.packages = with pkgs; [
      swww
      wallpaperchanger
    ];
  };
}
