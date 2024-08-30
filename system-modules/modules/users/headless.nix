{ pkgs, lib, config, ... }:
{
  options = {
    headless.enable = lib.mkEnableOption "enables headless user";
  };

  config = lib.mkIf config.headless.enable {
    users.users.headless = {
      isNormalUser = true;
      shell = pkgs.fish;
      extraGroups = [ "wheel" "networkmanager" "audio"];
    };
  };
}