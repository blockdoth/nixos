{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.modules.dev.vscode;
in
{
  config = lib.mkIf module.enable {

    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          jnoortheen.nix-ide
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
          jupyter.notebookFileRoot = "\${fileDirname}";
          jupyter.askForKernelRestart = "false";
          rust-analyzer.server.path = "rust-analyzer";
          vscode-pets.petSize = "medium";
          vscode-pets.throwBallWithMouse = true;
          git.blame.editorDecoration.enabled = true;
          nix.enableLanguageServer = true;
          nix.serverPath = "nixd";
          haskell.manageHLS = "PATH";
          workbench.startupEditor = "none";
          platformio-ide.useBuiltinPIOCore = false;
          editor.autoIndentOnPaste = true;
          files.associations = {
            "*.ispc" = "c";
          };
          security.workspace.trust = {
            enabled = false;
            startupPrompt = "never";
            baneer = "never";
          };
          "[svelte]" = {
            editor.defaultFormatter = "svelte.svelte-vscode";
          };
        };
      };
    };
  };
}
