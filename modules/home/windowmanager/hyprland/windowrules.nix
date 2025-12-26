{
  config,
  lib,
  ...
}:
let
  module = config.modules.windowmanager.hyprland;
in
{
  config = lib.mkIf module.enable {
    wayland.windowManager.hyprland.settings = {
      "$scratchpad" =
        "match:class ^(scratchpad.alacritty|spotify|Spotify|com.rtosta.zapzap|Signal|signal|obsidian)";
      "$pip" = "match:title ^(Picture-in-Picture)";
      "$popup" = "match:class ^(org.pulseaudio.pavucontrol|.blueman-manager-wrapped|Matplotlib)";

      windowrule = [
        #transparency
        "opacity 0.85, match:class ^(firefox|zen-beta)"
        "opacity 1.00, match:title ^(.*YouTube.*)"
        "opacity 0.75, match:class ^(spotify|Spotify)"
        "opacity 0.85, match:class ^(VSCodium|codium)"
        "opacity 0.9, match:class ^(dev.zed.Zed)"
        "opacity 0.85, match:class ^(vesktop)"
        "opacity 0.85, match:class ^(jetbrains)"
        "opacity 0.80, match:class ^(org.gnome.Nautilus)"
        "opacity 0.80, match:class ^(thunar)"
        "opacity 0.9, match:class ^(com.rtosta.zapzap)"
        "opacity 0.7, match:class ^(Signal|signal)"
        "opacity 0.9, match:class ^(anki)"
        "opacity 0.9, match:class ^(obsidian)"

        # "noblur,match:class ^(ghostty)$"
        #pip
        "float on,              $pip"
        "pin on,                $pip"
        "keep_aspect_ratio on,  $pip"
        "opaque on,             $pip"
        "size 800 450,          $pip"
        #popups
        "float on,              $popup"
        "pin on,                $popup"
        "size 40% 40%,          $popup"
        # Scratchpads
        "float on,                  $scratchpad"
        "workspace special silent,  $scratchpad"
        "center on,                 $scratchpad"
        "opacity 0.8,               $scratchpad"

        #BAR
        "float on,                  match:class Beyond-All-Reason"
        "center on,                  match:class Beyond-All-Reason"
        "fullscreen on,             match:class spring"

        "workspace 1,   match:class (vesktop)"
        "workspace 2,   match:class (firefox|zen-beta)"
        # "workspace 3,   match:class (VSCodium)"

        # prevent popups from having a weird border in vscode
        "no_blur on,    match:class ^()$, match:title ^()$"
        # make discord not steal focus
        "no_initial_focus on, match:class (vesktop)"
      ];

      layerrule = [
        "blur on, match:class logout_dialog"
        "blur on, match:class waybar"
        "blur off, match:class ^activate notification$"
      ];
    };
  };
}
