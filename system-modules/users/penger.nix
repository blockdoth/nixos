{ pkgs, lib, config, ... }:
{
  options = {
    system-modules.users.headless.enable = lib.mkEnableOption "enables headless user";
  };

  config = lib.mkIf config.system-modules.users.headless.enable {
    users.users.headless = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager"];
    };
  };
}