{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    modules.dev.editors.vscode.enable = lib.mkEnableOption "Enables vscode";
  };

  config = lib.mkIf config.modules.dev.editors.vscode.enable {
    home.packages = with pkgs; [ vscodium ];

    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
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
        window.title = "\${activeRepositoryName}\${folderName}";
        # clangd.arguments= ["--compile-commands-dir=/home/blockdoth/Documents/repos/c-web-server"];
        clangd.path = "/home/blockdoth/.config/VSCodium/User/globalStorage/llvm-vs-code-extensions.vscode-clangd/install/18.1.3/clangd_18.1.3/bin/clangd";
      };
    };

    #  home.file.".config/VSCodium/User/settings.json".text = ''
    #   {
    #     "files.autoSave": "afterDelay"
    #   }
    #  '';
  };
}
