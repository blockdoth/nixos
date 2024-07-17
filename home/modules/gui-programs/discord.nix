{ pkgs, config, lib, ... }:
{
  options = {
    discord.enable = lib.mkEnableOption "Enables discord";
  };

  config = lib.mkIf config.discord.enable {
    home.packages = with pkgs; [
      vesktop
    ];
  };
}