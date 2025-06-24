{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.modules.dev.editors.vscode;
in
{
  config = lib.mkIf module.enable {
    home.packages = with pkgs; [ vscodium ];

    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          jnoortheen.nix-ide
          llvm-vs-code-extensions.vscode-clangd
          mkhl.direnv
        ];
        userSettings = {
          files.autoSave = "afterDelay";
          editor.tabSize = 2;
          workbench.tree.indent = 15;
          editor.fontSize = 16;
          editor.detectIndentation = false;
          redhat.telemetry.enabled = false;
          workbench.colorTheme = "Stylix";
          workbench.tips.enabled = false;
          window.title = "VSCodium \${activeRepositoryName}";
          window.commandCenter = false;
          terminal.integrated.shellIntegration.enabled = false;
          window.titleBarStyle = "native";
          workbench.secondarySideBar.showLabels = false;
          window.customTitleBarVisibility = "never";
          # clangd.arguments= ["--compile-commands-dir=/home/blockdoth/Documents/repos/c-web-server"];
          clangd.path = "/home/blockdoth/.config/VSCodium/User/globalStorage/llvm-vs-code-extensions.vscode-clangd/install/18.1.3/clangd_18.1.3/bin/clangd";
          haskell.manageHLS = "GHCup";
          jupyter.notebookFileRoot = "\${fileDirname}";
          jupyter.askForKernelRestart = "false";
          rust-analyzer.server.path = "rust-analyzer";
          vscode-pets.petSize = "medium";
          vscode-pets.throwBallWithMouse = true;
          git.blame.editorDecoration.enabled = true;

        };
      };
    };
  };
}
