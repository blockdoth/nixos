{ pkgs, config, lib, ... }:
{
  options = {
    vscode.enable = lib.mkEnableOption "Enables vscode";
  };

  config = lib.mkIf config.vscode.enable {
    home.packages = with pkgs; [
      vscodium
    ];

	  programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
      ];  
    };  
  };
}
