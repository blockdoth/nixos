{
  config,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ./direnv/direnv.nix
    ./jetbrains.nix
    ./vscode.nix
    ./micro.nix
    ./neovim/neovim.nix
    ./neovim/nvf.nix
  ];
}
