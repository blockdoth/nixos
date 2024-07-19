{ config, lib, pkgs, ... }:
let 
  guiEnabled = config.modules.gui.enable;
  cliRiceEnabled = config.modules.cli-rice.enable;
in
{
  imports = [
    ./cli-programs
    ./gui-programs
    ./desktop-env
  ];

  options = {
    modules.gui.enable = lib.mkOption { type = lib.types.bool; default = false; };
    modules.cli-rice.enable = lib.mkOption { type = lib.types.bool; default = false; }; 
  };


  config = {
    # common
    shell.fish.enable = true;
    terminal.alacritty.enable = true;
  
    # desktop env
    compositor.wayland = {
      hyprland.enable = guiEnabled;
      logoutmenu.wlogout.enable = guiEnabled;
      lockscreen.hyprlock.enable = guiEnabled;
      idle.hypridle.enable = guiEnabled;
      applauncher.rofi.enable = guiEnabled;
      wallpaper.hyprpaper.enable = guiEnabled;
      taskbar.waybar.enable  = guiEnabled;
    };  

    notifications.dunst.enable = guiEnabled;
    custom-fonts.enable = false;
    custom-fonts.nerd.enable = false;

      
    # rice
    rice.enable = cliRiceEnabled;

    # cli programs
    git.enable = true;
    btop.enable = true;

    # gui programs
    firefox.enable = guiEnabled;
    discord.enable = guiEnabled;
    jetbrains.enable = guiEnabled;
    vscode.enable = guiEnabled;

  };
}

