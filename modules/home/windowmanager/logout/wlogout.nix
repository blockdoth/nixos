{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.modules.windowmanager.logout.wlogout;
  hover = "0";
  margin = "30";
  border-radius = "10";
  border-radius-active = "10";
  wlogout-script = pkgs.writeShellScriptBin "wlogout-script" (builtins.readFile ./wlogout.sh);
  colors = config.lib.stylix.colors;
in
{
  config = lib.mkIf module.enable {
    home.packages = with pkgs; [ wlogout-script ];
    programs.wlogout = {
      enable = true;
      layout = [
        {
          label = "logout";
          action = "hyprctl dispatch exit 0";
          text = "Logout";
          keybind = "e";
        }
        {
          label = "lock";
          action = "pidof hyprlock | hyprlock";
          text = "Lock";
          keybind = "l";
        }
        {
          label = "shutdown";
          action = "systemctl poweroff";
          text = "Shutdown";
          keybind = "s";
        }
        {
          label = "suspend";
          action = "systemctl suspend";
          text = "Suspend";
          keybind = "h";
        }
        {
          label = "reboot";
          action = "systemctl reboot";
          text = "Reboot";
          keybind = "r";
        }
      ];

      style =
        # css
        ''
          * {
              background-image: none;
              font-size: 20px;
              color: rgba(230, 230, 230, 0.8);
            }
            
            window {
              background-color: rgba(30, 30, 30, 0.4);
            }

            button {
              background-color: rgba(35, 35, 35, 0.7);
              outline-style: none;
              border: none;
              border-width: 0px;
              background-repeat: no-repeat;
              background-position: center;
              background-size: 20%;
              box-shadow: 10px 10px 10px 10px rgba(0 ,0 ,0 ,0.0);
              text-shadow: none;
              margin: 0px
            }
            
            button:hover  {
              background-color: rgba(80, 80, 80, 0.7);
              background-size: 25%;
              animation: gradient_f 2s ease-in infinite;
              transition: all 0.3s cubic-bezier(.55,0.0,.28,1.682);
            }

            #logout {
              background-image: image(url("${./icons/logout_white.png}"));
              border-radius: ${border-radius}px 0px 0px ${border-radius}px;
              margin : ${margin}px 0px ${margin}px ${margin}px;
            }

            #logout:hover {
              border-radius: ${border-radius-active}px;
              margin : ${hover}px 0px ${hover}px ${margin}px;
            }

            #lock {
              background-image: image(url("${./icons/lock_white.png}"));
              border-radius: 0px 0px 0px 0px;
              margin : ${margin}px 0px ${margin}px 0px;
            }

            #lock:hover {
              border-radius: ${border-radius-active}px;
              margin : ${hover}px 0px ${hover}px 0px;
            }

            #shutdown {
              background-image: image(url("${./icons/shutdown_white.png}"));
              border-radius: 0px 0px 0px 0px;
              margin : ${margin}px 0px ${margin}px 0px;
            }

            #shutdown:hover {
              border-radius: ${border-radius-active}px;
              margin : ${hover}px 0px ${hover}px 0px;
            }

            #suspend {
              background-image: image(url("${./icons/suspend_white.png}"));
              border-radius: 0px 0px 0px 0px;
              margin : ${margin}px 0px ${margin}px 0px;
            }
            
            #suspend:hover {
              border-radius: ${border-radius-active}px;
              margin : ${hover}px 0px ${hover}px 0px;
            }

            #reboot {
              background-image: image(url("${icons/reboot_white.png}"));
              border-radius: 0px ${border-radius}px ${border-radius}px 0px;
              margin : ${margin}px ${margin}px ${margin}px 0px;
            }

            #reboot:hover {
              border-radius: ${border-radius-active}px;
              margin : ${hover}px ${margin}px ${hover}px 0px;
            }
        '';
    };
  };

}
