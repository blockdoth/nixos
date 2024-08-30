{ pkgs, lib, config, ... }:
{
  options = {
    blockdoth.enable = lib.mkEnableOption "enables user blockdoth";
  };

  config = lib.mkIf config.blockdoth.enable{
    security.sudo.wheelNeedsPassword = false;
    users.users.blockdoth = {
      isNormalUser = true;
      shell = pkgs.fish;
      extraGroups = [ "wheel" "networkmanager" "audio"];
    };
  };
}