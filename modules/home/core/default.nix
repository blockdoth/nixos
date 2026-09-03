{ ... }:
{
  imports = [

    ./fonts
    ./style/cli.nix
    ./style/stylix.nix
    ./terminal/alacritty.nix
    ./terminal/ghostty/ghostty.nix

    ./shell.nix
    ./secrets.nix
    ./home-structure.nix
    ./mimes.nix
    ./utils.nix
    # ./impermanence.nix
  ];
}
