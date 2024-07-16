_:
let custom = {
    # font = "JetBrainsMono Nerd Font";
    font_size = "15px";
    font_weight = "bold";
    text_color = "#cdd6f4";
    secondary_accent= "89b4fa";
    tertiary_accent = "f5f5f5";
    background = "11111B";
    opacity = "0.98";
};
in 
{
  programs.waybar = {
    enable = true;
    
    systemd = {
      enable = false;
      target = "graphical-session.target";
    };

    settings = {
      mainBar = {
        position= "bottom";
        layer= "top";
        height= 5;
        margin-top= 0;
        margin-bottom= 0;
        margin-left= 0;
        margin-right= 0;
        modules-left= [
          # "custom/launcher" 
          "hyprland/workspaces"
        ];
        modules-center= [
          "clock"
        ];
        modules-right= [
          "tray" 
          "cpu"
          "memory"
          "disk"
          "network"
        ];

        clock= {
          calendar = {
            format = { today = "<span color='#b4befe'><b><u>{}</u></b></span>"; };
          };
          format = " {:%H:%M}";
          tooltip= "true";
          tooltip-format= "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt= " {:%d/%m}";
        };

        "hyprland/workspaces"= {
          active-only= false;
          disable-scroll= true;
          format = "{icon}";
          on-click= "activate";
          format-icons= {
            "1"= "󰈹";
            "2"= "";
            "3"= "󰘙";
            "4"= "󰙯";
            "5"= "";
            "6"= "";
            urgent= "";
            default = "";
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

      memory= {
        format= "󰟜 {}%";
        format-alt= "󰟜 {used} GiB"; # 
        interval= 2;
      };
      
      cpu= {
        format= "  {usage}%";
        format-alt= "  {avg_frequency} GHz";
        interval= 2;
      };
      disk = {
        # path = "/";
        format = "󰋊 {percentage_used}%";
        interval= 60;
      };

      network = {
        format-wifi = "  {signalStrength}%";
        format-ethernet = "󰀂 ";
        tooltip-format = "Connected to {essid} {ifname} via {gwaddr}";
        format-linked = "{ifname} (No IP)";
        format-disconnected = "󰖪 ";
      };

      tray= {
        icon-size= 20;
        spacing= 8;
      };
    

    };
  };
  style = ''
    * {
      border: none;
      border-radius: 0px;
      padding: 0;
      margin: 0;
      min-height: 0px;
      font-weight: ${custom.font_weight};
      opacity: ${custom.opacity};
    }

    window#waybar {
      background: none;
    }

    #workspaces {
      font-size: 18px;
      padding-left: 15px;
    }
    
    #workspaces button {
      color: ${custom.text_color};
      padding-left:  6px;
      padding-right: 6px;
    }
      
    #workspaces button.empty {
      color: #6c7086;
    }
      
    #workspaces button.active {
      color: #b4befe;
    }

    #tray, #network, #cpu, #memory, #disk, #clock, {
      font-size: ${custom.font_size};
      color: ${custom.text_color};
    }

    #cpu {
      padding-left: 15px;
      padding-right: 9px;
      margin-left: 7px;
    }
    #memory {
      padding-left: 9px;
      padding-right: 9px;
    }
    #disk {
      padding-left: 9px;
      padding-right: 15px;
    }

    #tray {
      padding: 0 20px;
      margin-left: 7px;
    }

    #network {
      padding-left: 9px;
      padding-right: 30px;
    }
    
    #clock {
      padding-left: 9px;
      padding-right: 15px;
    }
    '';
    };
}
