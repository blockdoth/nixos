{ config, lib, inputs, ...}:
{
  imports = [
    ./direnv.nix
    ./editors/jetbrains.nix
    ./editors/vscode.nix
    ./editors/neovim/neovim.nix
  ];

}
