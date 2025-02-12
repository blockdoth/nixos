{
  config,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ./direnv.nix
    ./editors/jetbrains.nix
    ./editors/vscode.nix
    ./editors/micro.nix
    ./editors/neovim/neovim.nix
    ./editors/neovim/nvf.nix
  ];

}
