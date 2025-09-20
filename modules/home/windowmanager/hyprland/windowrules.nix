{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.modules.windowmanager.hyprland;
in
{
  config = lib.mkIf module.enable {
    wayland.windowManager.hyprland.settings = {
      "$scratchpad" = "class:^(scratchpad|spotify|Spotify|com.rtosta.zapzap|Signal|signal|obsidian)";
      "$pip" = "title:^(Picture-in-Picture)";
      "$popup" = "class:^(org.pulseaudio.pavucontrol|.blueman-manager-wrapped|Matplotlib)";

      windowrulev2 = [
        #transparency
        "opacity 0.85, class:^(firefox)"
        "opacity 1.00, title:^(.*YouTube.*)"
        "opacity 0.75, class:^(spotify|Spotify)"
        "opacity 0.85, class:^(VSCodium|codium)"
        "opacity 0.85, class:^(vesktop)"
        "opacity 0.85, class:^(jetbrains)"
        "opacity 0.80, class:^(org.gnome.Nautilus)"
        "opacity 0.80, class:^(thunar)"
        "opacity 0.9, class:^(com.rtosta.zapzap)"
        "opacity 0.7, class:^(Signal|signal)"
        "opacity 0.9, class:^(anki)"
        "opacity 0.9, class:^(obsidian)"

        # "noblur,class:^(ghostty)$"
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

        # prevent popups from having a weird border in vscode
        "noblur,        class:^()$,title:^()$"
        # make discord not steal focus
        "noinitialfocus, class:(vesktop)"
      ];

      layerrule = [
        "blur, logout_dialog"
        "blur, waybar"
      ];
    };
  };
}
