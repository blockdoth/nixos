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
    };  
  };
}
