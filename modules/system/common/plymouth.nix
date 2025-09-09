{
  config,
  lib,
  pkgs,
  ...
}:
let
  module = config.system-modules.common.plymouth;
in
{
  config = lib.mkIf module.enable {
    #disabled boot animations because it breaks booting
    boot.plymouth = {
      enable = false;
      theme = lib.mkForce "rings"; # Prevent conflict with stylix
      themePackages = with pkgs; [
        # By default we would install all themes
        (adi1090x-plymouth-themes.override { selected_themes = [ "rings" ]; })
      ];
    };
  };
}
