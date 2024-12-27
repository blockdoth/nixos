{
  config,
  lib,
  pkgs,
  ...
}:
{

  config =
    let
      screen2gif = pkgs.writeShellScriptBin "screen2gif" ''
        TMP_FILE_UNOPTIMIZED="/home/blockdoth/Videos/recording_unoptimized.gif"
        TMP_PALETTE_FILE="/home/blockdoth/Videos/palette.png"
        TMP_FILE="/home/blockdoth/Videos/recording.gif"
        TMP_MP4_FILE="/home/blockdoth/Videos/recording.mp4"
        APP_NAME="GIF recorder"

        is_recorder_running() {
          pgrep -x wf-recorder >/dev/null
        }

        convert_to_gif() {
          ffmpeg -i "$TMP_MP4_FILE" -filter_complex "[0:v] palettegen" "$TMP_PALETTE_FILE"
          ffmpeg -i "$TMP_MP4_FILE" -i "$TMP_PALETTE_FILE" -filter_complex "[0:v] fps=10, [new];[new][1:v] paletteuse" "$TMP_FILE_UNOPTIMIZED"
          if [ -f "$TMP_PALETTE_FILE" ]; then
            rm "$TMP_PALETTE_FILE"
          fi
          if [ -f "$TMP_MP4_FILE" ]; then
            rm "$TMP_MP4_FILE"
          fi
        }

        notify() {
          notify-send -a "$APP_NAME" "$1"
        }

        optimize_gif() {
          gifsicle -O3 --lossy=100 -i "$TMP_FILE_UNOPTIMIZED" -o "$TMP_FILE"
          if [ -f "$TMP_FILE_UNOPTIMIZED" ]; then
            rm "$TMP_FILE_UNOPTIMIZED"
          fi
        }

        if is_recorder_running; then
          kill $(pgrep -x wf-recorder)
        else
          GEOMETRY=$(slurp)
          if [[ ! -z "$GEOMETRY" ]]; then
            if [ -f "$TMP_FILE" ]; then
              rm "$TMP_FILE"
            fi
            notify "Started capturing GIF to clipboard."
            timeout 30 wf-recorder -g "$GEOMETRY" -f "$TMP_MP4_FILE"
            if [ $? -eq 124 ]; then
              notify "Post-processing started. GIF capturing timed out."
            else
              notify "Post-processing started. GIF was stopped."
            fi
            convert_to_gif
            wl-copy -t image/png < $TMP_FILE
            notify "GIF capture completed. GIF saved to clipboard and $TMP_FILE"
          fi
        fi
      '';
    in
    lib.mkIf config.modules.core.windowmanager.tiling.hyprland.enable {
      home.packages = with pkgs; [
        screen2gif
        slurp
        gifsicle
      ];

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
          "SUPER,G,exec,ghostty"
          "SUPER,H, togglespecialworkspace, magic"
          "SUPER,H, movetoworkspace, +0"
          "SUPER,H, togglespecialworkspace, magic"
          "SUPER,H, movetoworkspace, special:magic"
          "SUPER,H, togglespecialworkspace, magic"
          # "SUPER,I,exec,alacritty msg config window.opacity=0.5"
          # "SUPER,H,movefocus,l"
          # "SUPER,K,exec,slurp | xargs -I {} wf-recorder -g {} -f ~/Videos/recording_$(date +\"%Y-%m-%d_%H-%M-%S\").mp4"
          # "SUPER,J,exec,killall -s SIGINT wf-recorder"

          "SUPER,L,exec,pidof hyprlock | hyprlock"
          "SUPER SHIFT,L,exec,systemctl suspend"

          "SUPER,M,exec,hyprctl dispatch toggleopaque"
          "SUPER,N,fullscreen"
          "SUPER,O,pseudo,"
          "SUPER,P,pin,"
          "SUPER,Q,killactive"
          "SUPER,R,exec,rofi -show drun -show-icons"
          "SUPER,S,exec, pypr toggle spotify"
          "SUPER,T,exec,alacritty"
          "SUPER,U,exec,"
          "SUPER,V,togglefloating"
          "SUPER,W,exec,wlogout-script"
          "SUPER,X,exec,pypr attach"
          "SUPER,Y,exec,codium ~/nixos"
          "SUPER,Z, exec, pypr zoom "
          "SUPER SHIFT,Z, exec, pypr zoom ++0.6"
          "SUPER SHIFT, S, exec, grimblast --notify --freeze copysave area"
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
          # Media keys
          ",XF86AudioPlay,exec,playerctl -a play-pause"
          ",XF86AudioStop,exec,playerctl -a stop"
          ",XF86AudioPrev,exec,playerctl -a previous"
          ",XF86AudioNext,exec,playerctl -a next"

          # Volume Keys
          ",XF86AudioRaiseVolume,exec,pactl set-sink-volume @DEFAULT_SINK@ +5%"
          ",XF86AudioLowerVolume,exec,pactl set-sink-volume @DEFAULT_SINK@ -5%"
          ",XF86AudioMute,exec,pactl set-sink-mute @DEFAULT_SINK@ toggle"
          ",XF86Calculator,exec,firefox -new-tab https://www.desmos.com/calculator"
          # ",,exec,kill hyprlock && hyprlock"
        ];
      };
    };
}
