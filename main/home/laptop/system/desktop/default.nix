{pkgs, ...}: {
  home.packages = with pkgs; [
    waybar
    dunst
    swww
    rofi
  ];

	programs = {

  };
}



