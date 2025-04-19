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
        # globals.mapleader = "";

        options = {
          # signcolumn = "no";
        };
        debugger = {
          nvim-dap = {
            enable = true;
            ui.enable = true;
          };
        };
        spellcheck.enable = true;

        lsp = {
          lightbulb.enable = true;
          formatOnSave = true;
        };
        languages = {
          enableLSP = true;
          enableFormat = true;
          enableTreesitter = true;
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
          motion = {
            hop.enable = true;
            leap.enable = true;
            precognition.enable = true;
          };
          yazi-nvim.enable = true;
          multicursors.enable = true;
          surround.enable = true;
        };

        visuals = {
          nvim-scrollbar.enable = true;
          indent-blankline.enable = true;
          cellular-automaton.enable = true;
        };

        git = {
          enable = true;
          gitsigns.enable = true;
        };

        projects = {
          project-nvim.enable = true;
        };

        notes = {
          todo-comments.enable = true;
        };

        terminal = {
          toggleterm = {
            enable = true;
            lazygit.enable = true;
          };
        };

        ui = {
          borders.enable = true;
          noice.enable = false;
          colorizer.enable = true;
        };

        dashboard.alpha.enable = true;
        mini.icons.enable = true;
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
