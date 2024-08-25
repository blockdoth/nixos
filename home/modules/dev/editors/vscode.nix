{ pkgs, config, lib, ... }:
{
  options = {
    modules.dev.editors.vscode.enable = lib.mkEnableOption "Enables vscode";
  };

  config = lib.mkIf config.modules.dev.editors.vscode.enable {
    home.packages = with pkgs; [
      vscodium
    ];

	  programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
        kamadorueda.alejandra 
      ];  
      userSettings = {
        files.autoSave = "afterDelay";
        editor.tabSize = 2;
        workbench.tree.indent = 12;
      };
    };  

    #  home.file.".config/VSCodium/User/settings.json".text = ''
    #   {
    #     "files.autoSave": "afterDelay"
    #   }
    #  '';
  };
}
