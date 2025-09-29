{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  module = config.modules.dev.nvf;
in
{
  # Inspiration
  # https://github.com/jsw08/niksos/blob/master/home/programs/neovim.nix
  imports = [
    inputs.nvf.homeManagerModules.default
  ];

  config = lib.mkIf module.enable {
    programs.nvf = {
      enable = true;
      enableManpages = true;
      settings.vim = {
        options = {
          # fillchars = {eob = " "};
          tabstop = 2;
          shiftwidth = 2;
        };

        theme = {
          enable = true;
          name = "gruvbox";
          style = "dark";
          transparent = true;
        };

        spellcheck.enable = true;
        enableLuaLoader = true;

        lsp = {
          lightbulb.enable = true;
          formatOnSave = true;
          trouble.enable = true;
          # lspSignature.enable = true;
          lspkind.enable = true;
        };
        languages = {
          enableLSP = true;
          enableFormat = true;
          enableTreesitter = true;

          clang = {
            enable = true;
            lsp.enable = true;
          };

          nix.enable = true;
          ts.enable = true;
          rust.enable = true;
          bash.enable = true;
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
          typst.enable = true;
        };

        binds = {
          cheatsheet.enable = true;
          whichKey.enable = true;
        };

        utility = {
          motion.precognition.enable = true;
          yazi-nvim.enable = true;
          multicursors.enable = true;
          surround.enable = true;
          oil-nvim.enable = true;
        };

        visuals = {
          nvim-scrollbar.enable = true;
          indent-blankline.enable = true;
          cellular-automaton.enable = true;
          highlight-undo.enable = true;
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

        filetree.neo-tree = {
          enable = true;
          setupOpts = {
            # enable_cursor_hijack = true;
            enable_git_status = true;
            enable_modified_markers = true;
            open_on_setup = true;
          };
        };
        autocomplete = {
          enableSharedCmpSources = true;
          blink-cmp = {
            enable = true;
          };
        };
        autopairs.nvim-autopairs.enable = true;
        dashboard.alpha.enable = true;
        mini = {
          surround.enable = true;
          icons.enable = true;
        };
        formatter.conform-nvim.enable = true;
        tabline.nvimBufferline.enable = true;
        telescope.enable = true;
        statusline.lualine.enable = true;

        keymaps = [
          # {
          #   key = "<leader>wq";
          #   mode = ["n"];
          #   action = ":wq<CR>";
          #   silent = true;
          #   desc = "Save file and quit";
          # }
        ];

      };
    };
  };
}
