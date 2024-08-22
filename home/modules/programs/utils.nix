{ pkgs, ... }:
{
  home.packages = with pkgs; [
    jq
    fd
    ripgrep
    fzf
  ];
}
  
  
  
  
