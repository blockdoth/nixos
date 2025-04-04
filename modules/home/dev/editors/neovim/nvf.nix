{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  module = config.modules.dev.editors.nvf;
in
{
  imports = [
    inputs.nvf.homeManagerModules.default
  ];

  config = lib.mkIf module.enable {
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
