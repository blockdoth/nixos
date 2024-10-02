{ config, lib, pkgs, inputs, ... }:
let 
  enableGnome           = config.modules.gnome.enable;
  enableHyprland        = config.modules.hyprland.enable;
  enableStackingWM      = enableGnome;
  enableTilingWM        = enableHyprland;
  enableGui             = enableStackingWM || enableTilingWM;
  enableDev             = config.modules.dev.enable;
  enablePrograms        = config.modules.programs.enable;
  enableTheming         = config.modules.theming.enable;
in
{
  imports = [
    ./core
    ./dev
    ./programs
  ];

  options =  with lib; {
    modules.hyprland.enable = mkOption { type = types.bool; default = false; };
    modules.gnome.enable    = mkOption { type = types.bool; default = false; };
    modules.dev.enable      = mkOption { type = types.bool; default = false; };
    modules.programs.enable = mkOption { type = types.bool; default = false; };
    modules.theming.enable  = mkOption { type = types.bool; default = false; };
  };

  config = with lib; {
    modules = {
      core = {
        windowmanager = {
          stacking = {
            gnome.enable = mkDefault enableGnome;
          };

          tiling = {
            hyprland.enable               = mkDefault enableHyprland;
            launcher.rofi.enable          = mkDefault enableTilingWM;
            lockscreen.hyprlock.enable    = mkDefault enableTilingWM;
            logout.wlogout.enable         = mkDefault enableTilingWM;
            taskbar.waybar.enable         = mkDefault enableTilingWM;
            wallpaper = {
              hyprpaper.enable  = mkDefault enableTilingWM;
              swww.enable       = mkDefault enableTilingWM;
            };
            widgets = {
              pyprland.enable   = mkDefault enableTilingWM;
              ags.enable        = mkDefault enableTilingWM;
            };
            idle.hypridle.enable          = mkDefault enableTilingWM;
            mediadeamon.mpd.enable        = mkDefault enableTilingWM;
            nightmode.gammastep.enable    = mkDefault enableTilingWM;
            notifications.dunst.enable    = mkDefault enableTilingWM;
          };
        };

        style = {
          fonts.enable          = mkDefault enableGui;
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
        firefox.enable        = mkDefault enablePrograms;
        activate-linux.enable = mkDefault false;
        discord.enable        = mkDefault enablePrograms;
        spotify.enable        = mkDefault enablePrograms;
        steam.enable          = mkDefault enablePrograms;
        minecraft.enable      = mkDefault enablePrograms;
      };
    };

    assertions =
      [ 
        { 
          assertion = enableGui || !(enableGui && enablePrograms);
          message = "In order to enable programs, the GUI must be enabled";
        } 
        { 
          assertion = enableGui || !(enableGui && enableDev);
          message = "In order to enable dev tools, the GUI must be enabled";
        } 
      ];
  };
}

