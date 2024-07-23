{ pkgs, config, lib, ... }:
{
  options = {
    compositor.wayland.logoutmenu.wlogout.enable = lib.mkEnableOption "Enables wlogout";
  };

  config = lib.mkIf config.compositor.wayland.logoutmenu.wlogout.enable {
    programs.wlogout = {
      enable = true;
      style =
        /*
        css
        */
        ''
        * {
            background-image: none;
            font-size: 30px;
          }
          window {
            background-color: rgba(70, 70, 70, 0.7);
          }

          button {
            color: rgba(127, 127, 127, 0.9);
            background-color: rgba(127, 127, 127, 0.9);
            outline-style: none;
            border: none;
            border-width: 0px;
            background-repeat: no-repeat;
            background-position: center;
            background-size: 20%;
            border-radius: 0px;
            box-shadow: none;
            text-shadow: none;
            animation: gradient_f 10s ease-in infinite;
          
          }
          
          button:hover  {
            background-color: rgba(100, 100, 100, 1);
            background-size: 30%;
            border-radius: 10px;
            animation: gradient_f 20s ease-in infinite;
            transition: all 0.3s cubic-bezier(.55,0.0,.28,1.682);
          }

          #logout {
            background-image: image(url("./icons/logout_white.png"));
          }

          #lock {
            background-image: image(url("./icons/lock_white.png"));
          }

          #suspend {
            background-image: image(url("./icons/suspend_white.png"));
          }
          #hibernate {
            background-image: image(url("./icons/hibernate_white.png"));
          }

          #shutdown {
            background-image: image(url("./icons/shutdown_white.png"));
          }

          #reboot {
            background-image: image(url("icons/reboot_white.png"));
          }
        '';
    };
  };


}