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
          show_branch_name = false;
          show_menus = true;
        };
        minimap = {
          show = "auto";

        };
        autosave = {
          after_delay = {
            milliseconds = 500;
          };
        };
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
