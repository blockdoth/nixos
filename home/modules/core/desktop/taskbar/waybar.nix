{ pkgs, config, lib, ... }:
{
  options = {
    modules.core.desktop.taskbar.waybar.enable = lib.mkEnableOption "Enables waybar";
  };

  config = lib.mkIf config.modules.core.desktop.taskbar.waybar.enable {
    programs.waybar = {
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
                    "tray" 
                ];
                modules-center= [
                    "clock"
                ];
                modules-right= [
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
                    format = "  ";
                    on-click = "rofi -show drun";
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

                temperature = {
                    critical-threshold = 80;
                    format = " {temperatureC}°C";
                };

                memory= {
                    format = "   {percentage}%";
                    format-alt = "  {used} GB / {total} GB";
                    interval= 2;
                };

                cpu= {
                    format= "  {usage}%";
                    interval= 2;
                };

                disk = {
                    # path = "/";
                    format= "  {percentage_used}%";
                    format-alt = "  {used} / {total}";
                    interval= 60;
                    unit = "GB";
                };

                network = {
                    format-wifi = "{icon}";
                    format-ethernet = "";
                    format-disconnected = "󰌙 ";
                    format-icons = [
                        "󰤯 "
                        "󰤟 "
                        "󰤢 "
                        "󰤢 "
                        "󰤨 "
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

                # pulseaudio = {
                #         format = "{volume}% {icon}";
                #         format-bluetooth = "{volume}% {icon}";
                #         format-bluetooth-muted = "{icon} {format_source}";
                #         format-muted = "{format_source}";
                #         format-source = "";
                #         format-source-muted = "";
                #         format-icons = {
                #             headphone = "";
                #             hands-free = "";
                #             headset = "";
                #             phone = "";
                #             portable = "";
                #             car = "";
                #             default = ["" "" ""];
                #     };
                #     on-click = "pavucontrol";
                # };

                tray = {
                    tooltip-format = "Connected to {essid} via {gwaddr}";
                    format-linked = "{ifname} (No IP)";
                    format-disconnected = "Disconnected";
                    format-ethernet = "Connected";
                    format-wifi = "{essid}";
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
            };
        };
        style = ''
            * {
                font-size: 7pt;
                min-height: 0;
                font-weight: bold;
                min-height: 0;
                border-radius: 5px;
                transition-property: background-color;
                transition-duration: 0.5s;
            }

            @keyframes blink_red {
                to {
                    background-color: rgb(242, 143, 173);
                    color: rgb(26, 24, 38);
                }
            }
            .warning, .critical, .urgent {
                animation-name: blink_red;
                animation-duration: 1s;
                animation-timing-function: linear;
                animation-iteration-count: infinite;
                animation-direction: alternate;
            }
            window#waybar {
                background-color: transparent;
            }
            window > box {
                background-color: rgba(30,30,42,0.5);
                border-color: #84A396;
                border-width: 2px;
            }
            #workspaces {
                padding-left: 0px;
                padding-right: 4px;
            }
            #workspaces button {
                padding-top: 0px;
                padding-bottom: 0px;
                padding-left: 6px;
                padding-right: 6px;
            }
            #workspaces button.active {
                background-color: rgb(65, 93, 197);
                color: rgb(26, 24, 38);
            }
            #workspaces button:hover {
                background-color: rgb(75, 75, 150);
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
                min-width: 20px;
                padding-left: 5px;
                padding-right: 5px;
                color: rgb(217, 224, 238);
                background-color: rgba(41, 61, 133, 0.9);
            }
        '';
        };
    };
}

