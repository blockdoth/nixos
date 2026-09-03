{
  config,
  lib,
  inputs,
  ...
}:
let
  enableGnome = config.modules.presets.gnome.enable;
  enableHyprland = config.modules.presets.hyprland.enable;
  enableDev = config.modules.presets.dev.enable;
  enablePrograms = config.modules.presets.programs.enable;
  enableTheming = config.modules.presets.theming.enable;
  enableGaming = config.modules.presets.gaming.enable;
  enableDefaults = config.modules.presets.defaults.enable;
  enableExtern = config.modules.presets.extern.enable;
  enableGui = enableGnome || enableHyprland;
  secrets = inputs.nixos-secrets;
  inherit (lib)
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
        defaults.enable = mkEnableOption "core configuration";
        extern.enable = mkEnableOption "default config for pc's I dont own";
        hyprland.enable = mkEnableOption "Hyprland";
        gnome.enable = mkEnableOption "Gnome";
        dev.enable = mkEnableOption "dev env and tools";
        programs.enable = mkEnableOption "user programs";
        theming.enable = mkEnableOption "theming";
        gaming.enable = mkEnableOption "gaming";
      };

      core = {
        secrets = {
          enable = mkEnableOption "secrets";
          mails = {
            uni = mkOption { type = types.str; };
            personal = mkOption { type = types.str; };
          };
          name = mkOption { type = types.str; };
        };
        style = {
          stylix.enable = mkEnableOption "theming";
          cli.enable = mkEnableOption "cli rice";
        };
        terminal = {
          alacritty.enable = mkEnableOption "Alacritty terminal";
          ghostty.enable = mkEnableOption "Ghostty terminal";
        };
        shell = {
          enable = mkEnableOption "shell";
          atuin.enable = mkEnableOption "atuin sync";
        };
        utils.enable = mkEnableOption "utils";
        impermanence.enable = mkEnableOption "impermanence";
        fonts.enable = mkEnableOption "fonts";
        home-structure.enable = mkEnableOption "default home structure";
        mimes.enable = mkEnableOption "mime types";
      };
      dev = {
        jetbrains.enable = mkEnableOption "jetbrains IDE's";
        vscode.enable = mkEnableOption "vscode IDE";
        zed.enable = mkEnableOption "zed";
        micro.enable = mkEnableOption "mini editor";
        neovim.enable = mkEnableOption "neovim";
        nvf.enable = mkEnableOption "nvf";
        direnv.enable = mkEnableOption "auto setup environment";
        devinit.enable = mkEnableOption "template shells";
        ctf.enable = mkEnableOption "ctf tools";
      };
      programs = {
        enable = mkEnableOption "discord";
        games.enable = mkEnableOption "games";
        browsers = {
          firefox.enable = mkEnableOption "firefox";
          zen.enable = mkEnableOption "zenbrowser";
          chromium.enable = mkEnableOption "chromium";
        };
      };

      windowmanager = {
        hyprland.enable = mkEnableOption "Hyprland DE";
        launcher.rofi.enable = mkEnableOption "Rofi launcher";
        lockscreen.hyprlock.enable = mkEnableOption "Hyprland based lockscreen";
        logout.wlogout.enable = mkEnableOption "logout screen";
        taskbar.waybar.enable = mkEnableOption "decent taskbar";
        wallpaper = {
          hyprpaper.enable = mkEnableOption "Hyprland based wallpaper util";
          awww.enable = mkEnableOption "Sway based wallpaper util";
        };
        pyprland.enable = mkEnableOption "Hyprland scratchpads";
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
      presets.defaults.enable = mkDefault (true && !enableExtern);
      core = {
        secrets = lib.mkIf (!enableExtern) {
          enable = mkDefault enableDefaults;
          mails = {
            uni = secrets.mails.uni;
            personal = secrets.mails.personal;
          };
          name = secrets.name;
        };

        shell = {
          enable = mkDefault (enableDefaults || enableExtern);
          atuin.enable = mkDefault enableDefaults;
        };

        style = {
          stylix.enable = mkDefault enableTheming;
          cli.enable = mkDefault enableTheming;
        };

        terminal = {
          alacritty.enable = mkDefault enableGui;
        };

        fonts.enable = mkDefault enableDefaults;
        utils.enable = mkDefault enableDefaults;
        home-structure.enable = mkDefault enableDefaults;
        mimes.enable = mkDefault enableDefaults;
      };

      dev = {
        micro.enable = mkDefault (enableDefaults || enableExtern);
        direnv.enable = mkDefault enableDev;
        devinit.enable = mkDefault enableDev;
        vscode.enable = mkDefault (enableGui && enableDev);
        zed.enable = mkDefault (enableGui && enableDev);
      };

      programs = {
        enable = mkDefault enablePrograms;
        games.enable = mkDefault enableGaming;
        browsers = {
          zen.enable = mkDefault enablePrograms;
        };
      };

      windowmanager = {
        hyprland.enable = mkDefault enableHyprland;
        launcher.rofi.enable = mkDefault enableHyprland;
        lockscreen.hyprlock.enable = mkDefault enableHyprland;
        logout.wlogout.enable = mkDefault enableHyprland;
        taskbar.waybar.enable = mkDefault enableHyprland;
        wallpaper.awww.enable = mkDefault enableHyprland;
        pyprland.enable = mkDefault enableHyprland;
        idle.hypridle.enable = mkDefault enableHyprland;
        nightmode.gammastep.enable = mkDefault enableHyprland;
        notifications.dunst.enable = mkDefault enableHyprland;
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
