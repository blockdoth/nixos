{ config, lib, ... }:
{
  config = lib.mkIf config.modules.core.windowmanager.tiling.hyprland.enable {
    wayland.windowManager.hyprland.settings = {

      layerrule = [
        "blur, logout_dialog"
        "blur, waybar"
      ];

      "$scratchpad" = "class:^(scratchpad|Spotify)";
      "$pip" = "title:^(Picture-in-Picture)";
      "$popup" = "class:^(pavucontrol|.blueman-manager-wrapped)";

      windowrulev2 = [
        #transpancy
        "opacity 0.85, class:^(firefox)"
        "opacity 1.00, title:^(.*YouTube.*)"
        "opacity 0.75, class:^(Spotify)"
        "opacity 0.85, class:^(VSCodium)"
        "opacity 0.80, class:^(vesktop)"
        "opacity 0.85, class:^(jetbrains)"
        "opacity 0.80, class:^(org.gnome.Nautilus)"

        "noblur,class:^(ghostty)$"
        #pip
        "float,           $pip"
        "pin,             $pip"
        "keepaspectratio, $pip"
        "opaque,          $pip"
        "size 40% 40%,    $pip"
        #popups
        "float,         $popup"
        "pin,           $popup"
        "size 40% 40%,  $popup"
        # Scratchpads
        "float,                     $scratchpad"
        "workspace special silent,  $scratchpad"
        "center,                    $scratchpad"
        "opacity 0.8,               $scratchpad"

        "workspace 1,   class:(firefox)"
        "workspace 2,   class:(VSCodium)"
        "workspace 3,   class:(vesktop)"

        # make discord not steal focus
        "noinitialfocus, class:(vesktop)"
      ];
    };
  };
}
