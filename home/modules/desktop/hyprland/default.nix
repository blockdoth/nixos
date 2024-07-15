{
  pkgs,
  inputs,
  ...
}: let
  gnomeSchema = "org.gnome.desktop.interface";
in {
  home.packages = with pkgs; [
    grim # Screenshot tool for hyprland
    waybar
    dunst
    swww
    rofi-wayland
    pyprland
    hyprpicker

  ];

  imports = [
    ./hypridle
    ./hyprlock
    ./waybar
    ./rofi
    ./hyprpaper
    ./wlogout
  ];


  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland; # hyprlandFlake or pkgs.hyprland
    xwayland.enable = true;



    settings = {
      "$mainMod" = "SUPER";
      monitor = [
          "eDP-1,2560x1440@144,auto,auto"
      ];

      exec-once = [
        
      ];


      xwayland = {
        force_zero_scaling = true;
      };


      input = {
        kb_layout = "us";
        touchpad = {
          natural_scroll = true;
        };
        # sensitivity = 0;
      };


      cursor = {
        # no_hardware_cursor = true;
      };

      general = {
        gaps_in = 2;
        gaps_out = 2;
        border_size = 2;
        layout = "dwindle";
        apply_sens_to_raw = 1; # whether to apply the sensitivity to raw input (e.g. used by games where you aim using your mouse)
      };

      decoration = {
        rounding = 2;
        shadow_ignore_window = true;
        drop_shadow = true;
        shadow_range = 10;
        shadow_render_power = 3;
        blur = {
          enabled = true;
          size = 4;
          passes = 1;
          new_optimizations = true;
          ignore_opacity = true;
          noise = 0.0117;
          contrast = 1.3;
          brightness = 1;
          xray = true;
        };
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
      };


      animations = {
        enabled = true;
        bezier = "myBezier,   0.05,   0.9,  0.1,  1.05";
        animation = [
          "windows,       1,  7,   myBezier"
          "windowsOut,    1,  7,   default,   popin 80%"
          "windowsMove,   1,  7,   myBezier"
          "border,        1,  10,  default"
          "borderangle,   1,  8,   default"
          "fade,          1,  7,   default"
          "workspaces,    1,  6,   default"
        ];
      };


      bind = [
        "SUPER,T,exec,alacritty"
        "SUPER,F,exec,firefox"
        "SUPER,S,exec,rofi -show drun -show-icons"

        "SUPER,Q,killactive,"
        "SUPER,M,exit,"
        "SUPER,S,togglefloating,"
        "SUPER,g,togglegroup"
        # "SUPER,tab,changegroupactive"
        # "SUPER,P,pseudo,"

        # Vim binds
        "SUPER,h,movefocus,l"
        "SUPER,l,movefocus,r"
        "SUPER,k,movefocus,u"
        "SUPER,j,movefocus,d"

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

        #---------------------------------------------------------------#
        # Move active window to a workspace with mainMod + ctrl + [0-9] #
        #---------------------------------------------------------------#
        # "SUPER $mainMod CTRL, 1, movetoworkspace, 1"
        # "SUPER $mainMod CTRL, 2, movetoworkspace, 2"
        # "SUPER $mainMod CTRL, 3, movetoworkspace, 3"
        # "SUPER $mainMod CTRL, 4, movetoworkspace, 4"
        # "SUPER $mainMod CTRL, 5, movetoworkspace, 5"
        # "SUPER $mainMod CTRL, 6, movetoworkspace, 6"
        # "SUPER $mainMod CTRL, 7, movetoworkspace, 7"
        # "SUPER $mainMod CTRL, 8, movetoworkspace, 8"
        # "SUPER $mainMod CTRL, 9, movetoworkspace, 9"
        # "SUPER $mainMod CTRL, 0, movetoworkspace, 10"
        # "SUPER $mainMod CTRL, left, movetoworkspace, -1"
        # "SUPER $mainMod CTRL, right, movetoworkspace, +1"

        # same as above, but doesnt switch to the workspace

        "SUPER $mainMod SHIFT, 1, movetoworkspacesilent, 1"
        "SUPER $mainMod SHIFT, 2, movetoworkspacesilent, 2"
        "SUPER $mainMod SHIFT, 3, movetoworkspacesilent, 3"
        "SUPER $mainMod SHIFT, 4, movetoworkspacesilent, 4"
        "SUPER $mainMod SHIFT, 5, movetoworkspacesilent, 5"
        "SUPER $mainMod SHIFT, 6, movetoworkspacesilent, 6"
        "SUPER $mainMod SHIFT, 7, movetoworkspacesilent, 7"
        "SUPER $mainMod SHIFT, 8, movetoworkspacesilent, 8"



      ];

      bindm = [
        # Mouse binds
        "SUPER,mouse:272,movewindow"
        "SUPER,mouse:273,resizewindow"
      ];

      bindle = [
           # Backlight Keys
           ",XF86MonBrightnessUp,exec,light -A 5"
           ",XF86MonBrightnessDown,exec,light -U 5"
           # Volume Keys
           ",XF86AudioRaiseVolume,exec,pactl set-sink-volume @DEFAULT_SINK@ +5%  "
           ",XF86AudioLowerVolume,exec,pactl set-sink-volume @DEFAULT_SINK@ -5%  "
      ];
    };
  };
}
