{
  ...
}:
{
  imports = [
    ../../modules/home/options.nix
  ];

  home = {
    username = "mowie";
    homeDirectory = "/home/mowie";
    stateVersion = "24.05";
  };

  modules = {
    presets = {

    };
  };
}
