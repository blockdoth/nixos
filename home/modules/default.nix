{ config, lib, pkgs, ... }:
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
    compositor.wayland = {
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

    notifications.dunst.enable = mkDefault guiEnabled;
    custom-fonts.enable = mkDefault true;

    # cli programs
    git.enable = mkDefault true;
    neovim.enable = mkDefault true;

    # gui programs
    terminal.alacritty.enable = mkDefault guiEnabled;
    firefox.enable = mkDefault guiEnabled;
    jetbrains.enable = mkDefault guiEnabled;
    vscode.enable = mkDefault guiEnabled;
    
    #dev
    #direnv.enable = true;
  };
}

