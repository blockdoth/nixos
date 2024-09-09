{ config, lib, ... }:
{
  config = lib.mkIf config.modules.core.windowmanager.tiling.hyprland.enable {    
    wayland.windowManager.hyprland.settings = {
      
      layerrule = [
        "blur, logout_dialog"
      ];
      
      "$scratchpad" = "class:^(scratchpad)$";
      "$pip"        = "title:^(Picture-in-Picture)$";
      "$pavu"       = "class:^(pavucontrol)$";
      
      windowrulev2 = [
        #transpancy
        "opacity 0.9, class:^(firefox)"
        "opacity 0.9, class:^(Spotify)"
        "opacity 0.9, class:^(VSCodium)"
        "opacity 0.9, class:^(vesktop)"
        "opacity 0.9, class:^(jetbrains)"
        "opacity 0.9, class:^(Nautilus)$"
        #pip
        "float,           $pip"
        "pin,             $pip"
        "keepaspectratio, $pip"
        "opaque, $pip"
        "size 40% 40%,    $pip"
        #pavucontrol
        "float,         $pavu"
        "pin,           $pavu"
        "size 40% 40%,  $pavu"
        # Scratchpads
        "float,                     $scratchpad"
        "size 90% 90%,              $scratchpad"
        "workspace special silent,  $scratchpad"
        "center,                    $scratchpad"
        
        # auto starts workspaces
        "workspace 1,   class:(firefox)"
        "workspace 2,   class:(VSCodium)"
        "workspace 3,   class:(vesktop)"
        # make discord not steal focus
        "noinitialfocus, class:(vesktop)"
      ];    
    };
  };
}

