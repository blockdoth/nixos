{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.modules.windowmanager.hyprland;
in
{
  config = lib.mkIf module.enable {

    home.keyboard = {
      enable = true;
      layout = "us";
      options = [ "caps:hyper" ];
    };

    wayland.windowManager.hyprland.settings = {
      binds = {
        allow_workspace_cycles = "yes";
      };

      bind = [
        "SUPER,A,exec, pypr toggle term"
        "SUPER,B,exec, zen"
        "SUPER,C,exec,hyprpicker -a"
        "SUPER,D,exec, pypr toggle signal"
        "SUPER,E,exec, pypr toggle obsidian"
        "SUPER,F,exec,thunar"
        "SUPER,G,exec,ghostty"
        "SUPER,H, togglespecialworkspace, magic"
        "SUPER,H, movetoworkspace, +0"
        "SUPER,H, togglespecialworkspace, magic"
        "SUPER,H, movetoworkspace, special:magic"
        "SUPER,H, togglespecialworkspace, magic"

        "SUPER,L,exec,pidof hyprlock | hyprlock"
        "SUPER SHIFT,L,exec,systemctl suspend"

        "SUPER,M, setprop, active opaque toggle"
        "SUPER,N,fullscreen"
        "SUPER,O,pseudo,"
        "SUPER,P,pin,"
        "SUPER,Q,killactive"
        "SUPER,R,exec,rofi -show drun -show-icons"
        "SUPER SHIFT,R,exec,zen -new-tab 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'"
        "SUPER,S,exec, pypr toggle spotify"
        "SUPER,T,exec,alacritty"
        # "SUPER,U,exec,"
        "SUPER,V,togglefloating"
        "SUPER,W,exec, pypr toggle whatsapp"
        "SUPER SHIFT,W,exec, wlogout-script"
        # "SUPER,X,exec,pypr attach"
        "SUPER,Y,exec,zeditor ~/nixos"
        "SUPER,Z, exec, pypr zoom "
        "SUPER SHIFT,Z, exec, pypr zoom ++0.6"
        "SUPER SHIFT, S, exec, grimblast --notify --freeze copysave area"
        ", PRINT, exec, grimblast --notify copysave screen"

        ################################## Move ###########################################
        "SUPER,left,movefocus,l"
        "SUPER,down,movefocus,r"
        "SUPER,up,movefocus,u"
        "SUPER,right,movefocus,d"

        "SUPER SHIFT, left, movewindow, l"
        "SUPER SHIFT, right, movewindow, r"
        "SUPER SHIFT, up, movewindow, u"
        "SUPER SHIFT, down, movewindow, d"

        "SUPER, left, movefocus, l"
        "SUPER, right, movefocus, r"
        "SUPER, up, movefocus, u"
        "SUPER, down, movefocus, d"

        "SUPER,1,workspace,1"
        "SUPER,2,workspace,2"
        "SUPER,3,workspace,3"
        "SUPER,4,workspace,4"
        "SUPER,5,workspace,5"
        "SUPER,6,workspace,6"
        "SUPER,7,workspace,7"

        "SUPER SHIFT,1,movetoworkspacesilent,1"
        "SUPER SHIFT,2,movetoworkspacesilent,2"
        "SUPER SHIFT,3,movetoworkspacesilent,3"
        "SUPER SHIFT,4,movetoworkspacesilent,4"
        "SUPER SHIFT,5,movetoworkspacesilent,5"
        "SUPER SHIFT,6,movetoworkspacesilent,6"
        "SUPER SHIFT,7,movetoworkspacesilent,7"

        "HYPER,1,workspace,11"
        "HYPER,2,workspace,12"
        "HYPER,3,workspace,13"
        "HYPER,4,workspace,14"
        "HYPER,5,workspace,15"
        "HYPER,6,workspace,16"
        "HYPER,7,workspace,17"

        "SUPER HYPER,1,movetoworkspacesilent,11"
        "SUPER HYPER,2,movetoworkspacesilent,12"
        "SUPER HYPER,3,movetoworkspacesilent,13"
        "SUPER HYPER,4,movetoworkspacesilent,14"
        "SUPER HYPER,5,movetoworkspacesilent,15"
        "SUPER HYPER,6,movetoworkspacesilent,16"
        "SUPER HYPER,7,movetoworkspacesilent,17"

        "SUPER,Tab,workspace,previous"
      ];

      bindm = [
        # Mouse binds
        "SUPER      ,mouse:272  ,movewindow"
        "SUPER SHIFT,mouse:272  ,resizewindow"
        "SUPER      ,mouse:273  ,resizewindow"
        "SUPER CTRL,mouse:272  ,togglefloating"

      ];

      bindle = [
        # Backlight Keys
        ",XF86MonBrightnessUp   ,exec,brightnessctl set +20"
        ",XF86MonBrightnessDown ,exec,brightnessctl set 20-"
        # Media keys
        ",XF86AudioPlay,exec,playerctl -a play-pause"
        ",XF86AudioStop,exec,playerctl -a stop"
        ",XF86AudioPrev,exec,playerctl -a previous"
        ",XF86AudioNext,exec,playerctl -a next"

        # Volume Keys
        ",XF86AudioRaiseVolume,exec,pactl set-sink-volume @DEFAULT_SINK@ +5%"
        ",XF86AudioLowerVolume,exec,pactl set-sink-volume @DEFAULT_SINK@ -5%"
        ",XF86AudioMute,exec,pactl set-sink-mute @DEFAULT_SINK@ toggle"
        ",XF86Calculator,exec,zen -new-tab https://www.desmos.com/calculator"
        # ",,exec,kill hyprlock && hyprlock"
      ];

      gesture = [
        "3, horizontal, workspace"
        # "2, pinchin, fullscreen"

      ];
    };
  };
}
