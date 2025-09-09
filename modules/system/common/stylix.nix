{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  module = config.system-modules.common.stylix;
in
{
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  config = lib.mkIf module.enable {
    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
      polarity = "dark";
      icons = {
        package = pkgs.papirus-icon-theme;
        # name = "Papirus-Dark";
      };
    };
  };
}
