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
  zenMode = config.modules.presets.zenmode.enable;
  enableStackingWM = enableGnome;
  enableTilingWM = enableHyprland;
  enableGui = enableStackingWM || enableTilingWM;
  secrets = inputs.nixos-secrets;
  inherit (lib)
    mkIf
    mkEnableOption
    mkDefault
    mkOption
    types
    ;
in
{
  imports = [
    ./core
    ./dev
    ./programs
    # inputs.home-manager.nixosModules.home-manager
  ];

  options = {

    modules = {
      presets = {
        hyprland.enable = mkEnableOption "Hyprland";
        gnome.enable = mkEnableOption "Gnome";
        dev.enable = mkEnableOption "dev env and tools";
        programs.enable = mkEnableOption "user programs";
        theming.enable = mkEnableOption "theming";
        zenmode.enable = mkEnableOption "zen mode";
      };
      secrets = {
        mails = {
          uni = mkOption { type = types.str; };
          personal = mkOption { type = types.str; };
        };
      };

      core = {
        impermanence.enable = mkEnableOption "impermanence";
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
            scratchpads.pyprland.enable = mkEnableOption "Hyprland scratchpads";
            idle.hypridle.enable = mkEnableOption "Hyprland based idle monitor";
            mediadeamon.mpd.enable = mkEnableOption "media deamon"; # TODO look at this again
            nightmode.gammastep.enable = mkEnableOption "nightmode";
            notifications.dunst.enable = mkEnableOption "notification daemon";
          };
        };

        style = {
          fonts.enable = mkEnableOption "fonts";
          theme.stylix.enable = mkEnableOption "theming";
          rice = {
            fastfetch.enable = mkEnableOption "fastfetch";
            cli.enable = mkEnableOption "cli";
            gui.enable = mkEnableOption "activate linux";
            cava.enable = mkEnableOption "cava";
          };
        };

        terminal = {
          alacritty.enable = mkEnableOption "Alacritty terminal";
          ghostty.enable = mkEnableOption "Ghostty terminal";
          shell = {
            prompt.starship.enable = mkEnableOption "prompt from starship";
            sync.atuin.enable = mkEnableOption "atuin shell sync";
            fish.enable = mkEnableOption "fish shell";
            zoxide.enable = mkEnableOption "zoxide navigation";
          };
        };

        infra = {
          git.enable = mkEnableOption "git";
          cli-utils.enable = mkEnableOption "various cli utilities";
          gui-utils.enable = mkEnableOption "various gui utilities";
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
        browsers = {
          firefox.enable = mkEnableOption "firefox";
          zenbrowser.enable = mkEnableOption "zenbrowser";
          chrome.enable = mkEnableOption "chrome";
        };
        discord.enable = mkEnableOption "discord";
        spotify.enable = mkEnableOption "spotify";
        llms.enable = mkEnableOption "llms";
        whatsapp.enable = mkEnableOption "whatsapp";
        signal.enable = mkEnableOption "signal";
        steam.enable = mkEnableOption "steam";
        minecraft.enable = mkEnableOption "minecraft";
        anki.enable = mkEnableOption "anki";
      };
    };
  };

  config = {
    # TODO find a better place for this
    programs.home-manager.enable = true;

    modules = {
      secrets = {
        mails = {
          uni = secrets.mails.uni;
          personal = secrets.mails.personal;
        };
      };
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
            scratchpads.pyprland.enable = mkDefault enableHyprland;

            idle.hypridle.enable = mkDefault enableTilingWM;
            nightmode.gammastep.enable = mkDefault enableTilingWM;
            notifications.dunst.enable = mkDefault enableTilingWM;
          };
        };

        style = {
          fonts.enable = mkDefault true;
          theme.stylix.enable = mkDefault true;
          rice = {
            fastfetch.enable = mkDefault enableTheming;
            cli.enable = mkDefault enableTheming;
            gui.enable = mkDefault (enableTheming && enableGui);
            cava.enable = mkDefault enableTheming;
          };
        };

        terminal = {
          alacritty.enable = mkDefault enableGui;
          shell = {
            prompt.starship.enable = mkDefault true;
            sync.atuin.enable = mkDefault true;
            fish.enable = mkDefault true;
            zoxide.enable = mkDefault true;
          };
        };

        infra = {
          git.enable = mkDefault true;
          cli-utils.enable = mkDefault true;
          secrets.enable = mkDefault true;
          home-structure.enable = mkDefault true;
          mimes.enable = mkDefault true;
          gui-utils.enable = mkDefault enableGui;
        };
      };
      dev = {
        editors = {
          micro.enable = mkDefault true;
          jetbrains.enable = mkDefault (enableDev && enableGui && !zenMode);
          vscode.enable = mkDefault (enableDev && enableGui && !zenMode);
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
          nautilus.enable = mkDefault false;
        };
        browsers = {
          zenbrowser.enable = mkDefault enableGui;
          firefox.enable = mkDefault enableGui;
          chrome.enable = mkDefault enableGui;
        };
        discord.enable = mkDefault (enableGui && !zenMode);
        spotify.enable = mkDefault enableGui;
        llms.enable = mkDefault enableGui;
        whatsapp.enable = mkDefault (enableGui && !zenMode);
        signal.enable = mkDefault (enableGui && !zenMode);
        steam.enable = mkDefault (enableGui && !zenMode);
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
