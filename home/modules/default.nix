{ config, lib, pkgs, inputs, ... }:
let 
  guiEnabled = config.modules.gui.enable;
in
{
  imports = [
    ./desktop
    ./programs
    ./dev
  ];

  options = {
    modules.gui.enable = lib.mkOption { type = lib.types.bool; default = false; };
  };


  config = with lib; {
    # common
    shell.fish.enable = true;
    prompt.starship.enable = true;

    # desktop env
    windowmanager.wayland = {
      hyprland.enable = mkDefault guiEnabled;
      logoutmenu.wlogout.enable = mkDefault guiEnabled;
      lockscreen.hyprlock.enable = mkDefault guiEnabled;
      idle.hypridle.enable = mkDefault guiEnabled;
      applauncher.rofi.enable = mkDefault guiEnabled;
      wallpaper.hyprpaper.enable = mkDefault guiEnabled;
      taskbar.waybar.enable  = mkDefault guiEnabled;
      widgets.pyprland.enable  = mkDefault guiEnabled;
      nightmode.gammastep.enable = mkDefault guiEnabled;
    };  

    # filebrowser = {
    #   dolphin.enable = mkDefault guiEnabled;
    #   yazi.enable = mkDefault true;
    # };

    notifications.dunst.enable = mkDefault guiEnabled;
    custom-fonts.enable = mkDefault true;

    git.enable = mkDefault true;
    neovim.enable = mkDefault true;

    terminal.alacritty.enable = mkDefault guiEnabled;
    firefox.enable = mkDefault guiEnabled;
    jetbrains.enable = mkDefault guiEnabled;
    vscode.enable = mkDefault guiEnabled;
    
    #dev
    #direnv.enable = true;
  };
}

