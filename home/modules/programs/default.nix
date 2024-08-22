{ ... }:
{
  imports = [
    ./firefox/firefox.nix
    ./git.nix
    ./jetbrains.nix
    ./vscode.nix
    ./neovim.nix
    ./fastfetch.nix
    ./utils.nix
  ];
}