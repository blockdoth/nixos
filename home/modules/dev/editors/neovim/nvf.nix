{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.nvf.homeManagerModules.default
  ];

  options = {
    modules.dev.editors.nvf.enable = lib.mkEnableOption "Enables neovim";
  };

  config = lib.mkIf config.modules.dev.editors.nvf.enable {
    programs.nvf = {
      enable = true;
      settings.vim = {
        theme = {
          enable = true;
          name = "gruvbox";
          style = "dark";
        };
        languages = {
          nix.enable = true;
        };
        telescope.enable = true;
        autocomplete.nvim-cmp.enable = true;
        statusline.lualine.enable = true;

      };
    };
  };
}
