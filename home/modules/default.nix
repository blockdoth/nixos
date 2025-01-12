{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  enableGnome = config.modules.gnome.enable;
  enableHyprland = config.modules.hyprland.enable;
  enableStackingWM = enableGnome;
  enableTilingWM = enableHyprland;
  enableGui = enableStackingWM || enableTilingWM;
  enableDev = config.modules.dev.enable;
  enablePrograms = config.modules.programs.enable;
  enableTheming = config.modules.theming.enable;
in
{
  imports = [
    ./core
    ./dev
    ./programs
  ];

  options = with lib; {
    modules.hyprland.enable = mkOption {
      type = types.bool;
      default = false;
    };
    modules.gnome.enable = mkOption {
      type = types.bool;
      default = false;
    };
    modules.dev.enable = mkOption {
      type = types.bool;
      default = false;
    };
    modules.programs.enable = mkOption {
      type = types.bool;
      default = false;
    };
    modules.theming.enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = with lib; {
    modules = {
      core = {
        windowmanager = {
          stacking = {
            gnome.enable = mkDefault enableGnome;
          };

          tiling = {
            hyprland.enable = mkDefault enableHyprland;
            launcher.rofi.enable = mkDefault enableTilingWM;
            lockscreen.hyprlock.enable = mkDefault enableTilingWM;
            logout.wlogout.enable = mkDefault enableTilingWM;
            taskbar.waybar.enable = mkDefault enableTilingWM;
            wallpaper = {
              hyprpaper.enable = mkDefault false;
              swww.enable = mkDefault enableTilingWM;
            };
            widgets = {
              pyprland.enable = mkDefault enableTilingWM;
              ags.enable = mkDefault enableTilingWM;
            };
            idle.hypridle.enable = mkDefault enableTilingWM;
            mediadeamon.mpd.enable = mkDefault false; # TODO look at this again
            nightmode.gammastep.enable = mkDefault enableTilingWM;
            notifications.dunst.enable = mkDefault enableTilingWM;
          };
        };

        style = {
          fonts.enable = mkDefault enableGui;
          theme.stylix.enable = mkDefault enableTheming;
          cava.enable = mkDefault (enableTheming && enableGui);
        };

        terminal = {
          alacritty.enable = mkDefault enableGui;
          ghostty.enable = mkDefault enableGui;
          prompt.starship.enable = mkDefault true;
          shell = {
            fish.enable = mkDefault true;
            sync.atuin.enable = mkDefault false;
          };
        };

        utils = {
          git.enable = mkDefault true;
          cli.enable = mkDefault true;
          gui.enable = mkDefault enableGui;
          secrets.enable = mkDefault false;
        };

      };

      dev = {
        editors = {
          neovim.enable = mkDefault enableDev;
          jetbrains.enable = mkDefault enableDev;
          vscode.enable = mkDefault enableDev;
        };
        env = {
          direnv.enable = mkDefault true;
        };
      };

      programs = {
        filebrowser = {
          dolphin.enable = mkDefault enablePrograms;
          yazi.enable = mkDefault true;
        };
        firefox.enable = mkDefault enablePrograms;
        activate-linux.enable = mkDefault enableGui;
        discord.enable = mkDefault enablePrograms;
        spotify.enable = mkDefault enablePrograms;
        steam.enable = mkDefault enablePrograms;
        minecraft.enable = mkDefault enablePrograms;
        zenbrowser.enable = mkDefault enablePrograms;
      };
    };

    assertions = [
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
