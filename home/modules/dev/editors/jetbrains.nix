{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    modules.dev.editors.jetbrains.enable = lib.mkEnableOption "Enables jetbrains idea's";
  };

  config = lib.mkIf config.modules.dev.editors.jetbrains.enable {
    home.packages = with pkgs; [
      jetbrains.clion
      jetbrains.webstorm
      jetbrains.pycharm-professional
      jetbrains.idea-ultimate
      jetbrains.rust-rover
    ];

    home.file =
      let
        file = ''
          -Xmx2048m
          -Dawt.toolkit.name=WLToolkit
        '';
      in
      {
        ".config/JetBrains/IntelliJIdea2024.1/idea64.vmoptions".text = file;
        ".config/JetBrains/PyCharm2024.1/pycharm64.vmoptions".text = file;
        ".config/JetBrains/CLion2024.1/clion64.vmoptions".text = file;
      };

  };
}
