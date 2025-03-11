{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.modules.dev.editors.jetbrains;
  vmOptions = ''
    -Xmx8192m
    -Dawt.toolkit.name=WLToolkit
  '';
in
{
  config = lib.mkIf module.enable {
    home.packages = with pkgs; [
      jetbrains.clion
      jetbrains.webstorm
      jetbrains.pycharm-professional
      # jetbrains.idea-ultimate
      jetbrains.rust-rover
    ];

    home.file = {
      ".config/JetBrains/IntelliJIdea2024.1/idea64.vmoptions".text = vmOptions;
      ".config/JetBrains/PyCharm2024.1/pycharm64.vmoptions".text = vmOptions;
      ".config/JetBrains/CLion2024.1/clion64.vmoptions".text = vmOptions;
    };

  };
}
