{ config, lib, pkgs, ... }:
let 
  guiEnabled = config.modules.gui.enable;
in
{
  imports = [
    ./desktop
    ./programs
    ./system
  ];

  options = {
    modules.gui.enable = lib.mkOption { type = lib.types.bool; default = false; };
  };


  config = {
    # common
    shell.fish.enable = true;
    terminal.alacritty.enable = true;
    prompt.starship.enable = true;
  
    # desktop env
    compositor.wayland = {
      hyprland.enable = lib.mkDefault guiEnabled;
      logoutmenu.wlogout.enable = lib.mkDefault guiEnabled;
      lockscreen.hyprlock.enable = lib.mkDefault guiEnabled;
      idle.hypridle.enable = lib.mkDefault guiEnabled;
      applauncher.rofi.enable = lib.mkDefault guiEnabled;
      wallpaper.hyprpaper.enable = lib.mkDefault guiEnabled;
      taskbar.waybar.enable  = lib.mkDefault guiEnabled;
    };  

    notifications.dunst.enable = lib.mkDefault guiEnabled;
    custom-fonts.enable = lib.mkDefault false;

    # cli programs
    git.enable = lib.mkDefault true;

    # gui programs
    firefox.enable = lib.mkDefault guiEnabled;
    jetbrains.enable = lib.mkDefault guiEnabled;
    vscode.enable = lib.mkDefault guiEnabled;

  };
}

