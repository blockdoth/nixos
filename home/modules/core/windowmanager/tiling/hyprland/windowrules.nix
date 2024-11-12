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
      "$pavu" = "class:^(pavucontrol)";

      windowrulev2 = [
        #transpancy
        "opacity 0.85, class:^(firefox)"
        "opacity 1.00, title:^(.*YouTube.*)"
        "opacity 0.75, class:^(Spotify)"
        "opacity 0.85, class:^(VSCodium)"
        "opacity 0.80, class:^(vesktop)"
        "opacity 0.85, class:^(jetbrains)"
        "opacity 0.85, class:^(*.Nautilus.*)"

        #pip
        "float,           $pip"
        "pin,             $pip"
        "keepaspectratio, $pip"
        "opaque,          $pip"
        "size 40% 40%,    $pip"
        #pavucontrol
        "float,         $pavu"
        "pin,           $pavu"
        "size 40% 40%,  $pavu"
        # Scratchpads
        "float,                     $scratchpad"
        "workspace special silent,  $scratchpad"
        "center,                    $scratchpad"
        "opacity 0.7,               $scratchpad"

        # make discord not steal focus
        "noinitialfocus, class:(vesktop)"
      ];
    };
  };
}
