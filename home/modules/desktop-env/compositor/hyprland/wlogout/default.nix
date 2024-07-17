{ pkgs, lib, config, ... }: 
{
  programs.wlogout = {
    enable = true;
    style =
      /*
      css
      */
      ''
        window {
          font-family: monospace;
          color: rgba(0,0,0,1);
          font-size: 14pt;
          background-color: rgba(70, 70, 70, 0.7);
        }

        button {
          background-repeat: no-repeat;
          background-position: center;
          background-size: 25%;
          border: none;
          background-color: rgba(127, 127, 127, 0.9);
          margin: 5px;
          transition: box-shadow 0.2s ease-in-out, background-color 0.2s ease-in-out;
        }

        button:hover  {
          background-color: rgba(100, 100, 100, 1);
        }

        #logout {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png"));
        }

        #lock {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png"));
        }


        #suspend {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"));
        }
        #hibernate {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png"));
        }

        #shutdown {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"));
        }

        #reboot {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"));
        }
      '';
  };
}