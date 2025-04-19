{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.modules.programs.spotify;
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  config = lib.mkIf module.enable {
    programs.spicetify = {
      enable = true;
      # enabledExtensions = with spicePkgs.extensions; [
      #   adblock
      #   # shuffle # shuffle+ (special characters are sanitized out of extension names)
      # ];
      theme = spicePkgs.themes.text;
      colorScheme = "Gruvbox";
    };
  };
}
