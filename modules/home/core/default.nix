{ ... }:
{
  imports = [

    ./fonts
    ./style

    ./shell/prompt/starship.nix
    ./shell/fish.nix
    ./shell/zoxide.nix
    ./shell/sync/atuin.nix
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
