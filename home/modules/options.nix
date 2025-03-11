{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  enableGnome = config.modules.presets.gnome.enable;
  enableHyprland = config.modules.presets.hyprland.enable;
  enableDev = config.modules.presets.dev.enable;
  enablePrograms = config.modules.presets.programs.enable;
  enableTheming = config.modules.presets.theming.enable;
  enableStackingWM = enableGnome;
  enableTilingWM = enableHyprland;
  enableGui = enableStackingWM || enableTilingWM;
  inherit (lib)
    mkIf
    mkEnableOption
    mkDefault
    mkOption
    ;
in
{
  imports = [
    ./core
    ./dev
    ./programs
  ];

  options = {

    modules = {
      presets = {
        hyprland.enable = mkEnableOption "Hyprland";
        gnome.enable = mkEnableOption "Gnome";
        dev.enable = mkEnableOption "dev env and tools";
        programs.enable = mkEnableOption "user programs";
        theming.enable = mkEnableOption "theming";
      };
      core = {
        windowmanager = {
          stacking = {
            gnome.enable = mkEnableOption "Gnome DE";
          };

          tiling = {
            hyprland.enable = mkEnableOption "Hyprland DE";
            launcher.rofi.enable = mkEnableOption "Rofi launcher";
            lockscreen.hyprlock.enable = mkEnableOption "Hyprland based lockscreen";
            logout.wlogout.enable = mkEnableOption "logout screen";
            taskbar.waybar.enable = mkEnableOption "decent taskbar";
            wallpaper = {
              hyprpaper.enable = mkEnableOption "Hyprland based wallpaper util";
              swww.enable = mkEnableOption "Sway based wallpaper util";
            };
            widgets = {
              ags.enable = mkEnableOption "JS widget framework";
              pyprland.enable = mkEnableOption "Hyprland utils system";
            };
            idle.hypridle.enable = mkEnableOption "Hyprland based idle monitor";
            mediadeamon.mpd.enable = mkEnableOption "media deamon"; # TODO look at this again
            nightmode.gammastep.enable = mkEnableOption "nightmode";
            notifications.dunst.enable = mkEnableOption "notification daemon";
          };
        };

        style = {
          fonts.enable = mkEnableOption "fonts";
          theme.stylix.enable = mkEnableOption "theming";
        };

        terminal = {
          alacritty.enable = mkEnableOption "Alacritty terminal";
          ghostty.enable = mkEnableOption "Ghostty terminal";
          prompt.starship.enable = mkEnableOption "prompt from starship";
          shell = {
            fish.enable = mkEnableOption "fish shell";
            zoxide.enable = mkEnableOption "zoxide navigation";
            sync.atuin.enable = mkEnableOption "atuin shell sync";
          };
        };

        utils = {
          git.enable = mkEnableOption "git";
          cli.enable = mkEnableOption "various cli utilities";
          gui.enable = mkEnableOption "various gui utilities";
          home-structure.enable = mkEnableOption "default home structure";
          mimes.enable = mkEnableOption "mime types";
          secrets.enable = mkEnableOption "secrets";
        };
      };
      dev = {
        editors = {
          jetbrains.enable = mkEnableOption "jetbrains IDE's";
          vscode.enable = mkEnableOption "vscode IDE";
          micro.enable = mkEnableOption "mini editor";
          neovim.enable = mkEnableOption "neovim";
          nvf.enable = mkEnableOption "nvf";
        };
        env = {
          direnv.enable = mkEnableOption "auto setup environment";
        };
      };
      programs = {
        filebrowser = {
          yazi.enable = mkEnableOption "yazi filebrowser";
          nautilus.enable = mkEnableOption "nautilus filebrowser";
          dolphin.enable = mkEnableOption "dolphin filebrowser";
        };
        firefox.enable = mkEnableOption "firefox";
        activate-linux.enable = mkEnableOption "activate linux";
        discord.enable = mkEnableOption "discord";
        spotify.enable = mkEnableOption "spotify";
        llms.enable = mkEnableOption "llms";
        whatsapp.enable = mkEnableOption "whatsapp";
        steam.enable = mkEnableOption "steam";
        minecraft.enable = mkEnableOption "minecraft";
        zenbrowser.enable = mkEnableOption "zenbrowser";
        anki.enable = mkEnableOption "anki";
      };
    };
  };

  config = {
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
              hyprpaper.enable = mkDefault false; # Caused issues
              swww.enable = mkDefault enableTilingWM;
            };
            widgets = {
              ags.enable = mkDefault false;
              pyprland.enable = mkDefault enableHyprland;
            };
            idle.hypridle.enable = mkDefault enableTilingWM;
            nightmode.gammastep.enable = mkDefault enableTilingWM;
            notifications.dunst.enable = mkDefault enableTilingWM;
          };
        };

        style = {
          fonts.enable = mkDefault true;
          theme.stylix.enable = mkDefault true;
        };

        terminal = {
          alacritty.enable = mkDefault enableGui;
          ghostty.enable = mkDefault enableGui;
          prompt.starship.enable = mkDefault enableGui;
          shell = {
            fish.enable = mkDefault true;
            zoxide.enable = mkDefault true;
            sync.atuin.enable = mkDefault true;
          };
        };

        utils = {
          git.enable = mkDefault true;
          cli.enable = mkDefault true;
          secrets.enable = mkDefault true;
          home-structure.enable = mkDefault true;
          mimes.enable = mkDefault true;
          gui.enable = mkDefault enableGui;
        };
      };
      dev = {
        editors = {
          micro.enable = mkDefault true;
          jetbrains.enable = mkDefault (enableDev && enableGui);
          vscode.enable = mkDefault (enableDev && enableGui);
          neovim.enable = mkDefault false;
          nvf.enable = mkDefault false;
        };
        env = {
          direnv.enable = mkDefault enableDev;
        };
      };
      programs = {
        filebrowser = {
          yazi.enable = mkDefault true;
          nautilus.enable = mkDefault enableGui;
        };
        firefox.enable = mkDefault enableGui;
        activate-linux.enable = mkDefault enableGui;
        discord.enable = mkDefault enableGui;
        spotify.enable = mkDefault enableGui;
        llms.enable = mkDefault enableGui;
        whatsapp.enable = mkDefault enableGui;
        steam.enable = mkDefault enableGui;
        zenbrowser.enable = mkDefault enableGui;
        anki.enable = mkDefault enableGui;
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
