{ pkgs, config, lib, inputs, ... }:
{
  options = {
    modules.core.style.theme.stylix.enable = lib.mkEnableOption "Enables stylix";
  }; 

  config = lib.mkIf config.modules.core.style.theme.stylix.enable {

    stylix = {
      enable = true;
      image = ../../../../assets/wallpapers/castle.png;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
      
      polarity = "dark";
      cursor = {
        # package = pkgs.oreo-cursors-plus;
        # name = "oreo_spark_orange_cursors";
        # size = 18;
      };
      fonts = {
        monospace = {
          package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
          name = "JetBrainsMono Nerd Font Mono";
        };
        sansSerif = {
          package = pkgs.raleway;
          name = "JetBrainsMono Nerd Font Mono";
        };
        serif = {
          package = pkgs.merriweather;
          name = "JetBrainsMono Nerd Font Mono";
        };

        
        sizes = {
          applications = 10;
          terminal = 10;
          desktop = 10;
          popups = 10;
        };

      };
      opacity = {
        applications = 0.7;
        terminal = 0.7;
        desktop = 0.7;
        popups = 0.8;
      };
      autoEnable = true;
      targets = {
        firefox.enable = false;
        rofi.enable = false;
        waybar.enable = false;
        hyprpaper.enable = lib.mkForce false;
      };
    };
  };
}