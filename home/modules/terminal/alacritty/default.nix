{pkgs, ...}:

{  
  home.packages = with pkgs; [
    alacritty
  ]; 
    

  programs.alacritty = {
    enable = true;
    settings = {
      env = {
        "TERM" = "xterm-256color";
      };

      window = {
        padding.x = 10;
        padding.y = 10;
        decorations = "buttonless";
      };

      font = {
        size = 10.0;
        # normal.family = "FuraCode Nerd Font";
        # bold.family = "FuraCode Nerd Font";
        # italic.family = "FuraCode Nerd Font";
      };

      cursor.style = "Beam";

      shell = {
        program = "fish";
        args = [
          "-C"
          "neofetch"
        ];
      };
    };
  };
}

