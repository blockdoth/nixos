{ pkgs, config, lib, ... }:
{
  options = {
    modules.core.desktop.taskbar.waybar.enable = lib.mkEnableOption "Enables waybar";
  };

  config = 
  let
    mediaplayer-state-file = "$HOME/waybar/mediaplayer-inputswitcher.state";

    # TODO move scripts somewhere else
    waybar-mediaplayer-playpause = pkgs.writeShellScriptBin "waybar-mediaplayer-playpause"
    ''
      STATE_FILE="$HOME/waybar/mediaplayer-inputswitcher.state"
      SELECTED_INDEX=$(cat $STATE_FILE)p 
      SELECTED_PLAYER=$(playerctl -l | sed -n $SELECTED_INDEX)
      playerctl --player=$SELECTED_PLAYER play-pause
    '';

    waybar-mediaplayer-info = pkgs.writeShellScriptBin "waybar-mediaplayer-info" 
      ''
      STATE_FILE="$HOME/waybar/mediaplayer-inputswitcher.state"
      SELECTED_INDEX=$(cat $STATE_FILE)p 

      # print nothing if nothing is playing
      if [[ $SELECTED_INDEX == "0p" ]]; then
        echo "|"
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


      METADATA=$(playerctl metadata --player=$SELECTED_PLAYER --format '{{artist}} - {{title}}')
      if [[ ''${#METADATA} > 40 ]]; then
        METADATA=$(echo $METADATA | cut -c1-40)"..."
      fi

      echo "| <span font='15' rise='-2pt'>$PLAYER_ICON $STATE_ICON</span> $METADATA |"
      '';

    waybar-mediaplayer-inputswitcher = pkgs.writeShellScriptBin "waybar-mediaplayer-inputswitcher" 
      ''
      # file to save the input state
      STATE_FILE="$HOME/waybar/mediaplayer-inputswitcher.state"    
      
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
  in
  lib.mkIf config.modules.core.desktop.taskbar.waybar.enable 
  {
    #import scripts
    home.packages = with pkgs; [
      waybar-mediaplayer-info
      waybar-mediaplayer-inputswitcher
      waybar-mediaplayer-playpause
    ];

    programs.waybar = 
    let
      colors = config.lib.stylix.colors;
      icon-size = "20";
      v-offset = "-4pt";
    in
    {
      enable = true;
    
      systemd = {
        enable = false;
        target = "graphical-session.target";
      };
      settings = {
        mainBar = {
          position= "top";
          layer= "top";
          spacing= 3;
          height= 13;
          modules-left= [
            "custom/logo"
            "hyprland/workspaces"
            "hyprland/window"
          ];
          modules-center= [
            "clock"
          ];
          modules-right= [
            "tray" 
            "custom/spotify"
            "pulseaudio"
            "temperature"
            "cpu"
            "memory"
            "disk"
            # "pulseaudio"
            "bluetooth"
            "network"
            "battery"
          ];

          clock= {
            calendar = {
              format = { today = "<span color='#b4befe'><b><u>{}</u></b></span>"; };
            };
            format = " {:%H:%M %d/%m/%y }";
          };
          
          "custom/logo" = {
            format = "<span font='${icon-size}'></span>";
            on-click = "wallpaperchanger";
            tooltip = false;
          };
          
          "custom/spotify" = {
            format = "{}";
            exec = "waybar-mediaplayer-info";
            exec-on-event = true;
            on-click = "waybar-mediaplayer-playpause";
            on-click-middle = "waybar-mediaplayer-inputswitcher";
            interval = 1;
            tooltip = false;
          };
          
          "hyprland/workspaces"= {
            active-only= false;
            disable-scroll= false;
            format = "{icon}";
            on-click= "activate";
            format-icons= {
              "1"= "1";
              "2"= "2";
              "3"= "3";
              "4"= "4";
              "5"= "5";
              urgent= "!";
              default = "*";
              sort-by-number= true;
            };

            persistent-workspaces = {
              "1"= [];
              "2"= [];
              "3"= [];
              "4"= [];
              "5"= [];
            };
          };
          "hyprland/window" = {
            "format" = "{}";
            "rewrite" = {
                "(.*) — Mozilla Firefox"  = "<span font='${icon-size}' rise='${v-offset}'>󰈹</span> $1";
                ".*Discord.*"             = "<span font='${icon-size}' rise='${v-offset}'></span> Discord";
                ".*VSCodium.*"            = "<span font='${icon-size}' rise='${v-offset}'></span> VSCodium";
                ".*Steam.*"               = "<span font='${icon-size}' rise='${v-offset}'></span> Steam";
                "Spotify"                 = "<span font='${icon-size}' rise='${v-offset}'></span> Spotify";
                ".*~.*"                   = "<span font='${icon-size}' rise='${v-offset}'></span> Alacritty";
            };
            "separate-outputs" = true;
          };

          temperature = {
            critical-threshold = 80;
            format     = "<span font='11' rise='0.8pt'></span> {temperatureC}°C |";
          };
          memory= {
            format     = "<span font='${icon-size}' rise='${v-offset}'></span> {percentage}% |";
            format-alt = "<span font='${icon-size}' rise='${v-offset}'></span> {used} GB / {total} GB |";
            interval= 5;
          };
          cpu= {
            format = "<span font='${icon-size}' rise='${v-offset}'></span> {usage:2}% |";
            interval = 2;
          };
          disk = {
            # path = "/";
            format      = "<span font='${icon-size}' rise='${v-offset}'></span> {percentage_used}% |";
            format-alt  = "<span font='${icon-size}' rise='${v-offset}'></span> {used} / {total} |";
            interval= 60;
            unit = "GB";
          };
          network = {
            tooltip-format      = "Connected to {essid} via {gwaddr}";
            format-wifi         = "{icon}";
            format-ethernet     = "<span font='15' rise='-2pt'>󱘖</span> Ethernet";
            format-disconnected = "<span font='15' rise='-2pt'></span> Disconnected";
            format-icons = [
              "<span font='${icon-size}' rise='${v-offset}'>󰤯</span> Wifi"
              "<span font='${icon-size}' rise='${v-offset}'>󰤟</span> Wifi"
              "<span font='${icon-size}' rise='${v-offset}'>󰤢</span> Wifi"
              "<span font='${icon-size}' rise='${v-offset}'>󰤢</span> Wifi"
              "<span font='${icon-size}' rise='${v-offset}'>󰤨</span> Wifi"
            ];
          };
          
          battery = {
            states = {
              good = 95;
              warning = 30;
              critical = 20;
            };
            format = "{icon} {capacity}%";
            format-charging = " {capacity}%";
            format-plugged = " {capacity}%";
            format-alt = "{time} {icon}";
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
            format                 = "<span font='${icon-size}' rise='-4.5pt'>{icon}</span> {volume:3}% |";
            format-bluetooth       = "<span font='${icon-size}' rise='-4.5pt'>{icon}</span> {volume:3}%  |";
            format-bluetooth-muted = "<span font='${icon-size}' rise='-4.5pt'>{icon}</span> {icon} {format_source} |";
            format-muted = "{format_source}";
            format-source = "";
            format-source-muted = "";
            format-icons = {
              headphone = "";
              default = ["" "" ""];
            };
            on-click = "pavucontrol";
            on-click-right = "pavucontrol";
          };

          mpd = {
            format= " {stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) |";
            format-disconnected= " Disconnected |";
            format-stopped= " {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped |";
            interval= 10;
            # consume-icons = {
            #   on = " "; 
            # };
            # random-icons = {
            #   off = "<span color=\"#f53c3c\"></span> "; 
            #   on = " ";
            # };
            # repeat-icons = {
            #   on = " ";
            # };
            # single-icons = {
            #   on = "1 ";
            # };
            # state-icons = {
            #   paused = "";
            #   playing = "";
            # };
            tooltip-format = "MPD (connected)";
            tooltip-format-disconnected = "MPD (disconnected)";
          };

          tray= {
            icon-size= 15;
            spacing= 8;
          };

          bluetooth = {
            format = "󰂯";
            format-no-controller = ""; # Hide when no bluetooth module detected
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
          border-radius: 11px;
          transition-property: background-color;
          transition-duration: 0.2s;
          color: #${colors.base07};
        }
        
        @keyframes blink_red {
          to {
            background-color: #${colors.base08};
            color: #${colors.base07};
          }
        }          


        window#waybar {
          background-color: rgba(60, 56, 54, 0.7); /* TODO fix this with stylix #${colors.base01} */
          border-width: 3px;
          border-color: rgba(80, 73, 69, 0.7); /* TODO fix this with stylix #${colors.base02} */
          border-style: solid;
          
        }
        

        .modules-left,
        .modules-center, 
        .modules-right 
        {
          margin: 0px 5px 0px 5px;
        }


        #window {
          padding-left: 5px;
          padding-right: 8px;
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
        #custom-logo
        {   
          margin-left: 5px;
          margin-right: 5px;
        }


        #custom-logo {
          margin-left: 10px;   
          padding: 0px;
        }
      '';
    };
  };
}
