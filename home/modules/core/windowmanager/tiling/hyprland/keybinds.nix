{ config, lib, ... }:
{
  config = lib.mkIf config.modules.core.windowmanager.tiling.hyprland.enable {    
    wayland.windowManager.hyprland.settings = {
      binds = {
        allow_workspace_cycles = "yes";
      };
  
      bind = [
        "SUPER,A,exec, pypr toggle term"
        "SUPER,B,exec,firefox"
        "SUPER,C,exec,hyprpicker -a" 
        "SUPER,D,exec,vesktop"
        "SUPER,E,exec,wallpaperchanger"
        "SUPER,F,exec,nautilus"
        # "SUPER,G,"
        "SUPER,H, togglespecialworkspace, magic"
        "SUPER,H, movetoworkspace, +0"
        "SUPER,H, togglespecialworkspace, magic"
        "SUPER,H, movetoworkspace, special:magic"
        "SUPER,H, togglespecialworkspace, magic"
        # "SUPER,I,"
        # "SUPER,H,movefocus,l"
        # "SUPER,K,movefocus,u"
        # "SUPER,J,movefocus,d"
        # "SUPER,L,movefocus,r"
        # "SUPER,M,"
        "SUPER,N,fullscreen" 
        "SUPER,O,pseudo,"
        "SUPER,P,pin,"
        "SUPER,Q,killactive"
        "SUPER,R,exec,rofi -show drun -show-icons"
        # "SUPER,S,"
        "SUPER,T,exec,alacritty"
        # "SUPER,U,"
        "SUPER,V,togglefloating"
        "SUPER,W,exec,wlogout -b 5"
        # "SUPER,X,"
        # "SUPER,Y,"
        "SUPER,Z, exec, pypr zoom "
        "SUPER SHIFT,Z, exec, pypr zoom ++0.6"
        "SUPER SHIFT, S, exec, grimblast --notify copysave area"
        ", PRINT, exec, grimblast --notify copysave screen"
        "SUPER,left,movefocus,l"
        "SUPER,down,movefocus,r"
        "SUPER,up,movefocus,u"
        "SUPER,right,movefocus,d"
        "SUPER,1,workspace,1"
        "SUPER,2,workspace,2"
        "SUPER,3,workspace,3"
        "SUPER,4,workspace,4"
        "SUPER,5,workspace,5"
        "SUPER,6,workspace,6"
        "SUPER,7,workspace,7"
        "SUPER,8,workspace,8"
        ################################## Move ###########################################
        "SUPER SHIFT, H, movewindow, l"
        "SUPER SHIFT, L, movewindow, r"
        "SUPER SHIFT, K, movewindow, u"
        "SUPER SHIFT, J, movewindow, d"
        "SUPER SHIFT, left, movewindow, l"
        "SUPER SHIFT, right, movewindow, r"
        "SUPER SHIFT, up, movewindow, u"
        "SUPER SHIFT, down, movewindow, d"
        # Move active window to a workspace with mainMod + ctrl + [0-9] #
        "SUPER SHIFT, 1, movetoworkspacesilent, 1"
        "SUPER SHIFT, 2, movetoworkspacesilent, 2"
        "SUPER SHIFT, 3, movetoworkspacesilent, 3"
        "SUPER SHIFT, 4, movetoworkspacesilent, 4"
        "SUPER SHIFT, 5, movetoworkspacesilent, 5"
        "SUPER SHIFT, 6, movetoworkspacesilent, 6"
        "SUPER SHIFT, 7, movetoworkspacesilent, 7"
        "SUPER SHIFT, 8, movetoworkspacesilent, 8"
        
        "SUPER,Tab,workspace,previous"
      ];
  
      bindm = [
        # Mouse binds
        "SUPER      ,mouse:272  ,movewindow"
        "SUPER SHIFT,mouse:272  ,resizewindow"
        "SUPER      ,mouse:273  ,resizewindow"
      ];
      
      bindle = [
          # Backlight Keys
          ",XF86MonBrightnessUp   ,exec,brightnessctl set +20"
          ",XF86MonBrightnessDown ,exec,brightnessctl set 20-"
          # Volume Keys
          ",XF86AudioRaiseVolume,exec,pactl set-sink-volume @DEFAULT_SINK@ +5%  "
          ",XF86AudioLowerVolume,exec,pactl set-sink-volume @DEFAULT_SINK@ -5%  "
      ];
    };
  };
}
