{ pkgs, config, lib, inputs,... }:
{
  options = {
    modules.core.desktop.windowmanager.hyprland.enable = lib.mkEnableOption "Enables hyprland";
  };

  config = lib.mkIf config.modules.core.desktop.windowmanager.hyprland.enable {
    
    home.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = 1;
      NIXOS_OZONE_WL = 1;
      # TODO fix this with stylix
      XCURSOR_SIZE = 15;
      HYPRCURSOR_SIZE = 15;
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
      pavucontrol
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.hyprland; # hyprlandFlake or pkgs.hyprland
      xwayland.enable = true;
      plugins = [
        # "${pkgs.hyprlandPlugins.hyprwinwrap}/lib/libhyprwinwrap.so"
      ];      
      settings = {
        debug = {
          disable_logs = false;
        };

        monitor = [
            "DP-2,2560x1440@143.972Hz,0x0,1"
        ];

        exec-once = [
          "waybar"
          "dunst"
          "hypridle"
          "pkill hyprpaper"
          "swww-daemon && swww img ../../../../../assets/wallpapers/rusty.jpg"
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

        plugins = {
          # hyprexpo = {
          #   columns = 3;
          #   gap_size = 5;
          #   bg_col = "rgb(111111)";
          #   workspace_method = "center current"; # [center/first] [workspace] e.g. first 1 or center m+1
          # };
          
          # crashes hyprland in combination with prismlauncher for some reason
          # hyprwinwrap = {
          #   class = "alacritty-bg";
          # };
        };

        general = {
          gaps_in = 3;
          gaps_out = 3;
          border_size = 3;
          # "col.active_border" = lib.mkForce "rgba(${config.lib.stylix.colors.base0B}ee)";
          # "col.inactive_border" = "rgba(6A9FB5aa)";
          apply_sens_to_raw = 1; 
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
            # xray = true;
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
          bezier = "overshot,   0.05,   0.9,  0.1,  1.05";
          animation = [
            "windows,       1,  5,   overshot"
            "windowsOut,    1,  7,   overshot"
            "windowsMove,   1,  6,   overshot"
            "workspaces,    1,  4,   default"
            "fade,          1,  6,   default"
            "border,        1,  10,  default"
            "borderangle,   1,  8,   default"
          ];
        };

        binds = {
          allow_workspace_cycles = "yes";
        };

        # doesnt display the other layers, only
        layerrule = [
          "blur, logout_dialog"
        ];
        "$scratchpad" = "class:^(scratchpad)$";
        "$pip"        = "title:^(Picture-in-Picture)$";
        "$pavu"       = "class:^(pavucontrol)$";
        windowrulev2 = [
          #transpancy
          # "opacity 0.9, class:^(firefox)"
          "opacity 0.75, class:^(Spotify)"
          "opacity 0.75, class:^(VSCodium)"
          "opacity 0.75, class:^(vesktop)"
          "opacity 0.75, class:^(jetbrains)"

          #pip
          "float,         $pip"
          "pin,           $pip"
          "size 40% 40%,  $pip"

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
  };
}
