{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.modules.programs.games;
in
{
  config = lib.mkIf module.enable {
    home.packages = with pkgs; [
      # steam
      beyond-all-reason
    ];
    # home.persistence."/persist/home/${config.home.username}".directories = [
    #   {
    #     directory = ".local/share/Steam";
    #     method = "symlink";
    #   }
    # ];
  };
}
