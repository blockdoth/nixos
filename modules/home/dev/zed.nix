{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.modules.dev.zed;
in
{
  config = lib.mkIf module.enable {

    programs.zed-editor = {
      enable = true;
      installRemoteServer = true;
      userSettings = {
        title_bar = {
          show_sign_in = false;
          show_user_picture = false;
          show_on_boarding_banner = false;
          show_project_items = false;
          show_branch_name = false;
          show_menus = true;
        };
        toolbar = {
          breadcrumbs = false;
          quick_actions = false;
          selections_menu = false;
          agent_review = false;
          code_actions = false;
        };
        tab_bar = {
          show = true;
          show_nav_history_buttons = false;
        };
        collaboration_panel.button = false;
        notification_panel.button = false;
        search.button = false;
        minimap.show = "auto";
        autosave.after_delay.milliseconds = 500;
        buffer_font_features.calt = false;
        telemetry = {
          diagnostics = false;
          metrics = false;
        };
        load_direnv = "shell_hook";
        icon_theme = {
          mode = "system";
          dark = "VSCode Icons";
          light = "VSCode Icons Light";
        };
        tabs = {
          file_icons = true;
          show_diagnostics = "error";
          git_status = true;
        };
        disable_ai = true;
        auto_signature_help = true;
        languages = {
          Nix = {
            language_servers = [
              "nixd"
              "!nil"
            ];
            formatter.external.command = "treefmt";
            format_on_save = "on";
          };
          Rust = {
            formatter = "language_server";
            format_on_save = "on";
          };
        };
        lsp = {
          nixd = {
            settings = {
            };
          };
          rust-analyzer = {
            binary = {
              ignore_system_version = false;
            };
            initialization_options = {
              check.command = "clippy";
            };
          };
        };
      };
      extensions = [
        "html"
        "toml"
        "dockerfile"
        "elixir"
        "nix"
        "make"
        "latex"
        "csv"
        "cargotom"
        "zed-html-snippets"
        "rust-snippets-for-zed"
        "zed-vscode-icons-theme"
      ];
    };
  };
}
