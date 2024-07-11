{pkgs, ...}: {
  home.packages = with pkgs; [
    vscodium
    vesktop
    discord
    steam
    jetbrains.clion
    jetbrains.webstorm
    jetbrains.pycharm-community
    jetbrains.idea-ultimate
    firefox
  ];

	programs = {
    vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
      ];  
    };
  };
}
