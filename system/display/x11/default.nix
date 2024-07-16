{ ... }:
{
  services.xserver = {
    enable = true;
    xkb = {
      variant = "";
      layout = "us";
    };
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };  

}