{ pkgs, lib, config, ... }:
{
  options = {
    pepijn.enable = lib.mkEnableOption "enables user pepijn";
  };

  config = lib.mkIf config.pepijn.enable{
    security.sudo.wheelNeedsPassword = false;
    users.users.pepijn = {
      isNormalUser = true;
      shell = pkgs.fish;
      extraGroups = [ "wheel" "networkmanager"];
    };
  };
}