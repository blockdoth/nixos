{ pkgs, config, lib, ... }:
{
  options = {
    neovim.enable = lib.mkEnableOption "Enables neovim";
  };

  config = lib.mkIf config.neovim.enable {
    home.packages = with pkgs; [
      neovim
    ];

    # programs.nixvim = {
    #   enable = true;

    #   colorschemes.gruvbox.enable = true;
    #   plugins.lightline.enable = true;
    # };
  };
}
