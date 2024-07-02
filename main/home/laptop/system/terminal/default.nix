{pkgs, ...}:let
    catppuccin = import ./catppuccin.nix;
  in {  
  home.packages = with pkgs; [
    alacritty
  ];   

  programs.alacritty = {
    enable = true;
    settings = {
      inherit (catppuccin) colors;
      cursor = {
        style = {
          blinking = "Never";
        };
      };
      window = {
        #opacity = 0.95;
        #decorations = "none";
        padding = {
          x = 10;
          y = 10;
        };
      };
      keyboard.bindings = [
        #{
        #  key = "V";
        #  mods = "Control|Shift";
        #  action = "Paste";
        #}
      ];
    };
  };
}
