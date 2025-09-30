{
  config,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ./direnv.nix
    ./devinit.nix
    ./jetbrains.nix
    ./vscode.nix
    ./micro.nix
    ./neovim/neovim.nix
    ./neovim/nvf.nix
  ];
}
