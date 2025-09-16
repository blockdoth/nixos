{
  config,
  lib,
  pkgs,
  inputs,
  hostname,
  ...
}:
let
  enableGnome = config.modules.presets.gnome.enable;
  enableHyprland = config.modules.presets.hyprland.enable;
  enableDev = config.modules.presets.dev.enable;
  enablePrograms = config.modules.presets.programs.enable;
  enableTheming = config.modules.presets.theming.enable;
  enableGaming = config.modules.presets.gaming.enable;
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
    ./windowmanager
  ];

  options = {

    modules = {
      presets = {
        hyprland.enable = mkEnableOption "Hyprland";
        gnome.enable = mkEnableOption "Gnome";
        dev.enable = mkEnableOption "dev env and tools";
        programs.enable = mkEnableOption "user programs";
        theming.enable = mkEnableOption "theming";
        gaming.enable = mkEnableOption "gaming";
      };

      core = {
        secrets = {
          mails = {
            uni = mkOption { type = types.str; };
            personal = mkOption { type = types.str; };
          };
        };
        style = {
          stylix.enable = mkEnableOption "theming";
          fastfetch.enable = mkEnableOption "fastfetch";
          rice = {
            cli.enable = mkEnableOption "cli rice";
            gui.enable = mkEnableOption "gui rice";
          };
          cava.enable = mkEnableOption "cava";

        };
        terminal = {
          alacritty.enable = mkEnableOption "Alacritty terminal";
          ghostty.enable = mkEnableOption "Ghostty terminal";
        };
        shell = {
          prompt.starship.enable = mkEnableOption "prompt from starship";
          sync.atuin.enable = mkEnableOption "atuin shell sync";
          fish.enable = mkEnableOption "fish shell";
          zoxide.enable = mkEnableOption "zoxide navigation";
          television.enable = mkEnableOption "television";
          pay-respects.enable = mkEnableOption "pay-respects";
          fzf.enable = mkEnableOption "fzf";
          zellij.enable = mkEnableOption "zellij";
          command-not-found.enable = mkEnableOption "command-not-found";
          nix-index.enable = mkEnableOption "command-not-found";
        };

        impermanence.enable = mkEnableOption "impermanence";
        fonts.enable = mkEnableOption "fonts";
        utils = {
          cli.enable = mkEnableOption "various cli utilities";
          gui.enable = mkEnableOption "various gui utilities";
        };
        home-structure.enable = mkEnableOption "default home structure";
        mimes.enable = mkEnableOption "mime types";
        secrets.enable = mkEnableOption "secrets";
      };
      dev = {
        jetbrains.enable = mkEnableOption "jetbrains IDE's";
        vscode.enable = mkEnableOption "vscode IDE";
        micro.enable = mkEnableOption "mini editor";
        neovim.enable = mkEnableOption "neovim";
        nvf.enable = mkEnableOption "nvf";
        direnv.enable = mkEnableOption "auto setup environment";
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
        games.enable = mkEnableOption "games";
        minecraft.enable = mkEnableOption "minecraft";
        anki.enable = mkEnableOption "anki";
        mpd.enable = mkEnableOption "media deamon"; # TODO look at this again
        git.enable = mkEnableOption "git";
      };

      windowmanager = {
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
        nightmode.gammastep.enable = mkEnableOption "nightmode";
        notifications.dunst.enable = mkEnableOption "notification daemon";
      };
    };
  };

  config = {
    # TODO find a better place for this
    programs.home-manager.enable = true;

    modules = {
      core = {
        secrets = {
          mails = {
            uni = secrets.mails.uni;
            personal = secrets.mails.personal;
          };
        };

        shell = {
          prompt.starship.enable = mkDefault true;
          sync.atuin.enable = mkDefault true;
          fish.enable = mkDefault true;
          zoxide.enable = mkDefault true;
          fzf.enable = mkDefault true;
          zellij.enable = mkDefault true;
          # nix-index.enable = mkDefault true;
          # command-not-found.enable = mkDefault true;
          # pay-respects.enable = mkDefault true;
          # television.enable = mkDefault true;
        };

        style = {
          stylix.enable = mkDefault enableTheming;
          rice = {
            cli.enable = mkDefault enableTheming;
            gui.enable = mkDefault (enableTheming && enableGui);
          };
        };

        terminal = {
          alacritty.enable = mkDefault enableGui;
        };

        fonts.enable = mkDefault true;
        utils = {
          cli.enable = mkDefault true;
          gui.enable = mkDefault enableGui;
        };
        secrets.enable = mkDefault true;
        home-structure.enable = mkDefault true;
        mimes.enable = mkDefault true;
      };

      dev = {
        direnv.enable = mkDefault enableDev;
        micro.enable = mkDefault true;
        vscode.enable = mkDefault true;
      };

      programs = {
        filebrowser = {
          yazi.enable = mkDefault true;
        };
        browsers = {
          firefox.enable = mkDefault enableGui;
          chrome.enable = mkDefault enableGui;
        };
        git.enable = mkDefault true;
        discord.enable = mkDefault enableGui;
        spotify.enable = mkDefault enableGui;
        whatsapp.enable = mkDefault enableGui;
        signal.enable = mkDefault enableGui;
        anki.enable = mkDefault enableGui;
        games.enable = mkDefault enableGaming;
      };

      windowmanager = {
        hyprland.enable = mkDefault enableHyprland;
        launcher.rofi.enable = mkDefault enableTilingWM;
        lockscreen.hyprlock.enable = mkDefault enableTilingWM;
        logout.wlogout.enable = mkDefault enableTilingWM;
        taskbar.waybar.enable = mkDefault enableTilingWM;
        wallpaper = {
          swww.enable = mkDefault enableTilingWM;
        };
        scratchpads.pyprland.enable = mkDefault enableHyprland;
        idle.hypridle.enable = mkDefault enableTilingWM;
        nightmode.gammastep.enable = mkDefault enableTilingWM;
        notifications.dunst.enable = mkDefault enableTilingWM;
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
