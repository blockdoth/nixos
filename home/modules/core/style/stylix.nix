{
  pkgs,
  config,
  lib,
  inputs,
  hostname,
  ...
}:
{
  options = {
    modules.core.style.theme.stylix.enable = lib.mkEnableOption "Enables stylix";
  };

  config = lib.mkIf config.modules.core.style.theme.stylix.enable {
    home.sessionVariables = {
      XCURSOR_SIZE = config.stylix.cursor.size;
      HYPRCURSOR_SIZE = config.stylix.cursor.size;
    };

    stylix = {
      enable = true;
      image = ../../../../assets/wallpapers/castle.png;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
      polarity = "dark";

      cursor = {
        size = 15;
      };

      fonts =
        let
          fontpackage = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
        in
        {
          monospace = {
            package = fontpackage;
            name = "JetBrainsMono Nerd Font Mono";
          };
          sansSerif = {
            package = fontpackage;
            name = "JetBrainsMono Nerd Font Mono";
          };
          serif = {
            package = fontpackage;
            name = "JetBrainsMono Nerd Font Mono";
          };

          sizes =
            let
              fontsize =
                if hostname == "laptop" then
                  12
                else if hostname == "desktop" then
                  10
                else
                  12;
            in
            {
              applications = fontsize;
              terminal = fontsize;
              desktop = fontsize;
              popups = fontsize;
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
