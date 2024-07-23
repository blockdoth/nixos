{ pkgs, config, lib, ... }:
{
  options = {
    compositor.wayland.taskbar.waybar.enable = lib.mkEnableOption "Enables waybar";
  };

  config = lib.mkIf config.compositor.wayland.taskbar.waybar.enable {
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
                spacing= 5;
                height= 20;
                modules-left= [
                    "hyprland/workspaces"
                ];
                modules-center= [
                    "clock"
                ];
                modules-right= [
                    "tray" 
                    "temperature"
                    "cpu"
                    "memory"
                    "disk"
                    "network"
                ];

                clock= {
                    calendar = {
                        format = { today = "<span color='#b4befe'><b><u>{}</u></b></span>"; };
                    };
                    format = " {:%d/%m/%y %H:%M }";
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
                    format = "{temperatureC}°C";
                };

                memory= {
                    format= "{used} / {total} GiB";
                    interval= 2;
                };

                cpu= {
                    format= "{usage}%";
                    interval= 2;
                };
                disk = {
                    # path = "/";
                    format = "{used} / {total} GiB";
                    interval= 60;
                };

                network = {
                    tooltip-format = "Connected to {essid} {ifname} via {gwaddr}";
                    format-linked = "{ifname} (No IP)";
                    format-disconnected = "Disconnected";
                    format-ethernet = "Connected";
                    format-wifi = "{essid}";
                };

                tray= {
                    icon-size= 20;
                    spacing= 8;
                };
            };
        };
        style = ''
            * {
                font-family: "JetBrainsMono Nerd Font";
                font-size: 10pt;
                font-weight: bold;
                border-radius: 8px;
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
                margin-left: 5px;
                margin-right: 5px;
                margin-top: 5px;
                background-color: #1e1e2a;
                padding: 3px;
                padding-left:8px;
                border: 2px none #33ccff;
            }
            #workspaces {
                padding-left: 0px;
                padding-right: 4px;
            }
            #workspaces button {
                padding-top: 5px;
                padding-bottom: 5px;
                padding-left: 6px;
                padding-right: 6px;
            }
            #workspaces button.active {
                background-color: rgb(100, 100, 200);
                color: rgb(26, 24, 38);
            }
            #workspaces button:hover {
                background-color: rgb(75, 75, 150);
            }

            #mode, #clock, #memory, #temperature,#cpu,#disk, #temperature, #backlight, #pulseaudio, #network, #battery, #tray {
                padding-left: 10px;
                padding-right: 10px;
                color: rgb(217, 224, 238);
                background-color: rgb(100, 100, 200);
            }
        '';
        };
    };
}

