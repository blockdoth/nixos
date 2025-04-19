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
          transparent = true;
        };

        languages = {
          nix.enable = true;
          ts.enable = true;
          rust.enable = true;
          bash.enable = true;
          clang.enable = true;
          css.enable = true;
          html.enable = true;
          go.enable = true;
          python.enable = true;
          haskell.enable = true;
          java.enable = true;
          lua.enable = true;
          markdown.enable = true;
          kotlin.enable = true;
          sql.enable = true;
          yaml.enable = true;
        };

        binds = {
          cheatsheet.enable = true;
          whichKey.enable = true;
        };

        utility = {
          motion.precognition.enable = true;
        };

        visuals = {
          nvim-scrollbar.enable = true;
        };

        formatter.conform-nvim.enable = true;
        filetree.nvimTree.enable = true;
        tabline.nvimBufferline.enable = true;
        telescope.enable = true;
        autocomplete.nvim-cmp.enable = true;
        statusline.lualine.enable = true;
      };
    };
  };
}
