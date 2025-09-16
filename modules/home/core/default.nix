{ ... }:
{
  imports = [

    ./fonts
    ./style
    ./shell

    ./terminal/alacritty.nix
    ./terminal/ghostty/ghostty.nix

    ./secrets.nix
    ./home-structure.nix
    ./mimes.nix
    ./utils/gui.nix
    # ./impermanence.nix
    ./utils/cli.nix
  ];
}
