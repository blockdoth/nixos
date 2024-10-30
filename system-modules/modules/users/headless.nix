{ pkgs, lib, config, ... }:
{
  options = {
    system-modules.headless.enable = lib.mkEnableOption "enables headless user";
  };

  config = lib.mkIf config.system-modules.headless.enable {
    users.users.headless = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager"];
    };
  };
}