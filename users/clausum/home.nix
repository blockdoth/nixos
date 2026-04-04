{
  ...
}:
{
  imports = [
    ../../modules/home/options.nix
  ];

  home = {
    username = "clausum";
    homeDirectory = "/home/clausum";
    stateVersion = "24.05";
  };

  modules = {
    presets = {
      defaults.enable = true;
      hyprland.enable = true;
      theming.enable = true;
    };
    programs.browsers.chrome.enable = true;
  };
}
