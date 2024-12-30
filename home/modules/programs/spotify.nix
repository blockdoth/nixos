{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  options = {
    modules.programs.spotify.enable = lib.mkEnableOption "Enables spotify";
  };
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  config =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    in
    lib.mkIf config.modules.programs.spotify.enable {

      programs.spicetify = {
        enable = true;
        # enabledExtensions = with spicePkgs.extensions; [
        #   adblock
        #   # shuffle # shuffle+ (special characters are sanitized out of extension names)
        # ];
        theme = spicePkgs.themes.text;
        colorScheme = "gruvbox";
      };
    };
}
