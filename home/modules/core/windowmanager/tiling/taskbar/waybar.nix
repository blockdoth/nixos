{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  options = {
    modules.core.windowmanager.tiling.taskbar.waybar.enable = lib.mkEnableOption "Enables waybar";
  };

  config =
    let
      toStr = var: builtins.toString var;
      mediaplayer-state-file = "$HOME/.local/state/waybar/mediaplayer-inputswitcher.state";

      # TODO move scripts somewhere else
      waybar-mediaplayer-playpause = pkgs.writeShellScriptBin "waybar-mediaplayer-playpause" ''
        STATE_FILE="${mediaplayer-state-file}"
        SELECTED_INDEX=$(cat $STATE_FILE)p 
        SELECTED_PLAYER=$(playerctl -l | sed -n $SELECTED_INDEX)
        playerctl --player=$SELECTED_PLAYER play-pause
      '';

      waybar-mediaplayer-info = pkgs.writeShellScriptBin "waybar-mediaplayer-info" ''
        STATE_FILE="${mediaplayer-state-file}"
        SELECTED_INDEX=$(cat $STATE_FILE)p 

        NUM_SOURCES=$(playerctl -l | wc -l)

        # Turn off module if nothing is playing 
        if [[ $NUM_SOURCES == "0" ]]; then
          exit
        fi

        SELECTED_PLAYER=$(playerctl -l | sed -n $SELECTED_INDEX)

        PLAYER_ICON=""
        if [[ $SELECTED_PLAYER == *"firefox"* ]]; then
          PLAYER_ICON="󰈹"
        elif [[ $SELECTED_PLAYER == *"spotify"* ]]; then
          PLAYER_ICON=""
        fi

        STATUS=$(playerctl metadata --player=$SELECTED_PLAYER --format '{{lc(status)}}')
        STATE_ICON=""
        if [[ $STATUS == "playing" ]]; then
          STATE_ICON=""
        fi

        if [[ $STATUS == "playing" ]]; then
          STATE_ICON=""
        fi

        METADATA=$(playerctl metadata --player=$SELECTED_PLAYER --format '{{artist}} - {{title}}')

        if [[ ''${#METADATA} > 30 ]]; then
          METADATA=$(echo $METADATA | cut -c1-30)"..."
        fi


        echo "| <span font='${toStr icon-size}pt' rise='${toStr (v-offset * -0.2)}pt'>$PLAYER_ICON $STATE_ICON</span> $METADATA "
      '';

      waybar-mediaplayer-inputswitcher = pkgs.writeShellScriptBin "waybar-mediaplayer-inputswitcher" ''
        # file to save the input state
        STATE_FILE="${mediaplayer-state-file}"    

        # create dir if it not exists 
        mkdir -p "$(dirname "$STATE_FILE")"

        # set default state if state file doesnt exist
        if [ ! -f "$STATE_FILE" ]; then
          echo "0" > "$STATE_FILE"  
        fi

        CURRENT_SOURCE=$(cat "$STATE_FILE")
        NUM_SOURCES=$(playerctl -l | wc -l)

        if [[ $NUM_SOURCES == "0" ]]; then
          echo "0" > "$STATE_FILE" 
        else
          echo $(((CURRENT_SOURCE % NUM_SOURCES) + 1)) > "$STATE_FILE"
        fi


        echo $(cat "$STATE_FILE") 
      '';
      colors = config.lib.stylix.colors;
      icon-size = config.stylix.fonts.sizes.desktop * 1.8;
      v-offset = config.stylix.fonts.sizes.desktop / 3.5 * -1;
    in
    lib.mkIf config.modules.core.windowmanager.tiling.taskbar.waybar.enable {
      #import scripts
      home.packages = with pkgs; [
        waybar-mediaplayer-info
        waybar-mediaplayer-inputswitcher
        waybar-mediaplayer-playpause
        inputs.iss-piss-stream.packages.${pkgs.system}.iss-piss-stream
      ];

      programs.waybar = {
        enable = true;

        systemd = {
          enable = false;
          target = "graphical-session.target";
        };
        settings = {
          mainBar = {
            position = "top";
            layer = "top";
            margin-left = 6;
            margin-right = 6;
            margin-top = 6;

            modules-left = [
              "custom/logo"
              "hyprland/workspaces"
              "hyprland/window"
            ];
            modules-center = [ "clock" ];
            modules-right = [
              "tray"
              "custom/media"
              "custom/piss"
              "pulseaudio"
              "bluetooth"
              "temperature"
              "cpu"
              "memory"
              "disk"
              "network"
              "battery"
            ];

            clock = {
              calendar = {
                format = {
                  today = " <span color='#b4befe'><b><u>{}</u></b></span>";
                };
              };
              format = " {:%H:%M %d/%m/%y }";
            };

            "custom/divider" = {
              format = " | ";
            };

            "custom/logo" = {
              format = "  <span font='${toStr icon-size}'></span> ";
              on-click = "wallpaperchanger";
              tooltip = false;
            };

            "custom/piss" = {
              format = "󰆫 {}%";
              format-alt = "ISS Urine tank level {}%";
              exec = "iss-piss-stream -p";
            };

            "custom/media" = {
              format = " {}";
              exec = "waybar-mediaplayer-info";
              exec-on-event = true;
              on-click = "waybar-mediaplayer-playpause";
              on-click-right = "waybar-mediaplayer-inputswitcher";
              interval = 1;
              tooltip = false;
            };

            "hyprland/workspaces" = {
              active-only = false;
              disable-scroll = false;
              format = "{icon}";
              on-click = "activate";
              format-icons = {
                "1" = "1";
                "2" = "2";
                "3" = "3";
                "4" = "4";
                "5" = "5";
                urgent = "!";
                default = "*";
                sort-by-number = true;
              };

              persistent-workspaces = {
                "1" = [ ];
                "2" = [ ];
                "3" = [ ];
                "4" = [ ];
                "5" = [ ];
              };
            };
            "hyprland/window" = {
              "format" = "{}";
              "rewrite" = {
                "(.*) — Mozilla Firefox" = " <span font='${toStr icon-size}pt' rise='${toStr (v-offset * -0.1)}pt'>󰈹</span>  $1";
                ".*Discord.*" = " <span font='${toStr icon-size}pt' rise='${toStr (v-offset * -0.1)}pt'></span>  Discord";
                ".*VSCodium.*" = " <span font='${toStr icon-size}pt' rise='${toStr (v-offset * -0.1)}pt'></span>  VSCodium";
                ".*Steam.*" = " <span font='${toStr icon-size}pt' rise='${toStr (v-offset * -0.1)}pt'></span>  Steam";
                "Spotify" = " <span font='${toStr icon-size}pt' rise='${toStr (v-offset * -0.1)}pt'></span>  Spotify";
                ".*~.*" = " <span font='${toStr icon-size}pt' rise='${toStr (v-offset * -0.1)}pt'></span>  Alacritty";
              };
              "separate-outputs" = true;
            };

            temperature = {
              critical-threshold = 80;
              format = "| <span font='${toStr (icon-size * 0.6)}' rise='${toStr (v-offset * -0.1)}pt'></span> {temperatureC}°C ";
              interval = 5;
            };
            memory = {
              format = "| <span font='${toStr icon-size}' rise='${toStr v-offset}pt'></span> {percentage}% ";
              format-alt = "| <span font='${toStr icon-size}' rise='${toStr v-offset}pt'></span> {used} GB / {total} GB ";
              interval = 3;
            };
            cpu = {
              format = "| <span font='${toStr icon-size}' rise='${toStr v-offset}pt'></span> {usage:2}% ";
              interval = 3;
            };
            disk = {
              # path = "/";
              format = "| <span font='${toStr icon-size}' rise='${toStr v-offset}pt'></span> {percentage_used}% ";
              format-alt = "| <span font='${toStr icon-size}' rise='${toStr v-offset}pt'></span> {used} / {total} ";
              interval = 60;
              unit = "GB";
            };
            network = {
              format-wifi = "| <span font='${toStr icon-size}' rise='${toStr v-offset}pt'>{icon}</span> ";
              format-ethernet = "| <span font='15' rise='-2pt'>󱘖</span> ";
              format-disconnected = "| <span font='15' rise='-2pt'></span> ";
              tooltip-format = "Connected to {essid} via {gwaddr}";
              format-icons = [
                "󰤯"
                "󰤟"
                "󰤢"
                "󰤢"
                "󰤨"
              ];
            };

            battery = {
              interval = 3;
              states = {
                good = 95;
                warning = 30;
                critical = 20;
              };
              format = "| <span font='${toStr (icon-size * 0.5)}' rise='${toStr (v-offset * -0.15)}pt'>{icon}</span> {capacity}% ";
              format-charging = "| <span font='${toStr (icon-size * 0.5)}' rise='${toStr (v-offset * -0.15)}pt'>󰂄</span> {capacity}% ";
              format-plugged = "| <span font='${toStr (icon-size * 0.5)}' rise='${toStr (v-offset * -0.15)}pt'></span> {capacity}% ";
              format-alt = "| <span font='${toStr (icon-size * 0.5)}' rise='${toStr (v-offset * -0.15)}pt'>{icon}</span> {time:10} @ {power:5} W ";
              format-icons = [
                "󰂎"
                "󰁺"
                "󰁻"
                "󰁼"
                "󰁽"
                "󰁾"
                "󰁿"
                "󰂀"
                "󰂁"
                "󰂂"
                "󰁹"
              ];
            };

            pulseaudio = {
              format = "| <span font='${toStr icon-size}' rise='${toStr (v-offset * 1)}pt'>{icon}</span> {volume:3}% ";
              format-bluetooth = "| <span font='${toStr icon-size}' rise='${toStr (v-offset * 1)}pt'>{icon}</span> {volume:3}%  ";
              format-bluetooth-muted = "| <span font='${toStr icon-size}' rise='${toStr (v-offset * 1)}pt'>{icon}</span> {icon} {format_source} ";
              format-muted = "{format_source}";
              format-source = "";
              format-source-muted = "|  ";
              format-icons = {
                headphone = "";
                default = [
                  ""
                  ""
                  ""
                ];
              };
              on-click = "pavucontrol";
              on-click-right = "pavucontrol";
            };

            tray = {
              spacing = 10;
            };

            bluetooth = {
              format = "| <span font='${toStr (icon-size * 0.5)}' rise='${toStr (v-offset * -0.3)}pt'>󰂯</span> ";
              format-no-controller = ""; # Hide when no bluetooth module detected
              on-click = "blueman-manager";
              tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
              tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
              tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
              tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
            };
            # pulseaudio = {
            #     format = "{icon} {volume}%"; 
            #     format-bluetooth = "B {icon} {volume}%"; 
            #     format-muted = "M {icon} {volume}%"; 
            # };

            # cava produces a segfault sadly
            # cava = {
            #   # cava_config = "$XDG_CONFIG_HOME/cava/cava.conf";
            #   framerate = 30;
            #   autosens = 1;
            #   sensitivity = 100;
            #   bars = 14;
            #   lower_cutoff_freq = 50;
            #   higher_cutoff_freq = 10000;
            #   method = "pulse";
            #   source = "auto";
            #   stereo = true;
            #   reverse = false;
            #   bar_delimiter = 0;
            #   monstercat = false;
            #   waves = false;
            #   noise_reduction = 0.77;
            #   input_delay = 2;
            #   format-icons = [
            #     "▁"
            #     "▂"
            #     "▃"
            #     "▄"
            #     "▅"
            #     "▆"
            #     "▇"
            #     "█" 
            #   ];
            #   actions = {
            #     on-click-right = "mode";
            #   };
            # };
          };
        };
        style = ''
          * {
            min-height: 0;
            font-weight: bold;
            border-radius: 8px;
            transition-property: background-color;
            transition-duration: 0.2s;
            color: #${colors.base07};
            font-size: ${toStr config.stylix.fonts.sizes.desktop}pt;
          }

          @keyframes blink_red {
            to {
              background-color: #${colors.base08};
              color: #${colors.base07};
            }
          }          


          window#waybar {
            background-color: rgba(60, 56, 54, 0.6); /* TODO fix this with stylix #${colors.base01} */
            border-width: 2px;
            border-color: rgba(80, 73, 69, 0.6); /* TODO fix this with stylix #${colors.base02} */
            border-style: solid;
          }


          .modules-left 
          {
            margin-left: 5px;
          }
          .modules-right 
          {
            margin-right: 10px;
          }

          #workspaces {
            margin: 4px 7px 4px 7px;
            border-radius: 8px;
            border-width: 2px;
            border-color: rgba(80, 73, 69, 0.5); /* TODO fix this with stylix #${colors.base02} */
            border-style: solid;
            background-color:  rgba(102, 92, 84, 0.5); /* TODO fix this with stylix #${colors.base03} */
          }

          #workspaces button {
            border: none;
            padding: 1px 2px 1px 2px;
            border-radius: 5px;
          }

          #workspaces button.active { 	
            background-color: rgba(131, 165, 152, 0.5); /* TODO fix this with stylix #${colors.base0D} */
            box-shadow: none;
            border: none;
          }

          #workspaces button:hover {
            background-color: rgba(189, 174, 147, 0.5); /* TODO fix this with stylix #${colors.base04} */
          }


          #mode, 
          #clock, 
          #memory, 
          #temperature,
          #cpu,
          #disk, 
          #temperature, 
          #backlight, 
          #pulseaudio, 
          #network, 
          #battery, 
          #tray,
          #bluetooth,
          #custom-logo,
          #custom-media
          {   
            border-radius: 0px;
            margin: 0px;
          }

        '';
      };
    };
}
