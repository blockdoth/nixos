{ pkgs, config, lib, ... }:
{
  options = {
    windowmanager.wayland.hyprland.enable = lib.mkEnableOption "Enables hyprland";
  };

  config = lib.mkIf config.windowmanager.wayland.hyprland.enable {
    
    home.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = 1;
      NIXOS_OZONE_WL = 1;
    };

    # todo seperate files maybe
    home.packages = with pkgs; [
      grimblast 
      hyprpicker
      wl-clipboard
      wf-recorder
      wlr-randr # screen stuff

      brightnessctl # Control background
      playerctl # Control audio
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.hyprland; # hyprlandFlake or pkgs.hyprland
      xwayland.enable = true;

      settings = {
        monitor = [
            "DP-1,2560x1440@144,0x0,1"
        ];

        exec-once = [
          "waybar"
          "dunst"
          "hypridle"
          "hyprpaper"
          "pypr"
          "gammastep"
          "[workspace 1 silent] firefox"
          "[workspace 2 silent] codium"
          "[workspace 3 silent] vesktop"
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
          gaps_in = 3;
          gaps_out = 3;
          border_size = 4;
          # "col.active_border" = "rgba(82B8C8ee)";
          # "col.inactive_border" = "rgba(6A9FB5aa)";
          apply_sens_to_raw = 1; # whether to apply the sensitivity to raw input (e.g. used by games where you aim using your mouse)
          layout = "dwindle";
        };

        decoration = {
          rounding = 5;
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

        dwindle = {
          preserve_split = true;
        };

        animations = {
          enabled = true;
          bezier = "myBezier,   0.05,   0.9,  0.1,  1.05";
          animation = [
            "windows,       1,  5,   myBezier"
            "windowsOut,    1,  7,   default,   popin 80%"
            "windowsMove,   1,  6,   myBezier"
            "border,        1,  10,  default"
            "borderangle,   1,  8,   default"
            "fade,          1,  6,   default"
            "workspaces,    1,  5,   default"
          ];
        };
        # doesnt display the other layers, only
        layerrule = [
          # "blur, logout_dialog"
        ];
        "$scratchpad" = "class:^(scratchpad)$";
        # "$pip" = "title:^(Picture-in-Picture)$";
        windowrulev2 = [
          # Scratchpads
          "float,                     $scratchpad"
          "size 90% 90%,              $scratchpad"
          "workspace special silent,  $scratchpad"
          "center,                    $scratchpad"
          
          # auto starts workspaces
          "workspace 1,   class:(firefox)"
          "workspace 2,   class:(VSCodium)"
          "workspace 3,   class:(vesktop)"
        ];

        bind = [
          "SUPER,A,exec, pypr toggle term"
          "SUPER,B,exec,firefox"
          "SUPER,C,exec,hyprpicker -a" 
          "SUPER,D,exec,vesktop"
          # "SUPER,E,"
          "SUPER,F,exec,nautilus"
          # "SUPER,G,"
          "SUPER,H,movefocus,l"
          # "SUPER,I,"
          "SUPER,K,movefocus,u"
          "SUPER,J,movefocus,d"
          "SUPER,L,movefocus,r"
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

        ];

        bindm = [
          # Mouse binds
          "SUPER      ,mouse:272  ,movewindow"
          "SUPER SHIFT,mouse:272  ,resizewindow"
          "SUPER      ,mouse:273  ,resizewindow"
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
  };
}
