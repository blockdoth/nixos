{ config, lib, pkgs, inputs, ... }:
let 
  enableGui      = config.modules.gui.enable;
  enableDev      = config.modules.dev.enable;
  enablePrograms = config.modules.programs.enable;
  enableTheming  = config.modules.theming.enable;
in
{
  imports = [
    ./core
    ./dev
    ./programs
  ];

  options =  with lib; {
    modules.gui.enable          = mkOption { type = types.bool; default = false; };
    modules.dev.enable          = mkOption { type = types.bool; default = false; };
    modules.programs.enable     = mkOption { type = types.bool; default = false; };
    modules.theming.enable      = mkOption { type = types.bool; default = false; };
  };


  config = with lib; {
    modules = {
      core = {
        desktop = {
          launcher.rofi.enable          = mkDefault enableGui;
          lockscreen.hyprlock.enable    = mkDefault enableGui;
          logout.wlogout.enable         = mkDefault enableGui;
          taskbar.waybar.enable         = mkDefault enableGui;
          wallpaper = {
            hyprpaper.enable  = mkDefault enableGui;
            swww.enable       = mkDefault enableGui;
          };
          widgets.pyprland.enable       = mkDefault enableGui;
          windowmanager.hyprland.enable = mkDefault enableGui;
        };
        services = {
          idle.hypridle.enable        = mkDefault enableGui;
          mediadeamon.mpd.enable      = mkDefault enableGui;
          nightmode.gammastep.enable  = mkDefault enableGui;
          notifications.dunst.enable  = mkDefault enableGui;
        };

        style = {
          fonts.enable          = mkDefault true;
          theme.stylix.enable   = mkDefault enableTheming;
        };

        terminal = {
          alacritty.enable        = mkDefault enableGui;
          prompt.starship.enable  = mkDefault true;
          shell.fish.enable       = mkDefault true;
        };

        utils = {
          base.enable   = mkDefault true;
          git.enable    = mkDefault true;
        };

      };

      dev = {
        editors = {
          neovim.enable     = mkDefault enableDev;
          jetbrains.enable  = mkDefault enableDev;
          vscode.enable     = mkDefault enableDev;
        };
        env = {
          direnv.enable     = mkDefault enableDev;
        };
      };

      programs = {
        filebrowser = {
          dolphin.enable  = mkDefault enablePrograms;
          yazi.enable     = mkDefault enablePrograms;
        };
        firefox.enable = mkDefault enablePrograms;
        discord.enable = mkDefault enablePrograms;
        spotify.enable = mkDefault enablePrograms;
      };
    };

    assertions =
      [ 
        { 
          assertion = enableGui || !(enableGui && enablePrograms);
          message = "In order to enable programs, the GUI must be enabled";
        } 
      ];
  };
}

