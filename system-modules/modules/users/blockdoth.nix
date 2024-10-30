{ pkgs, lib, config, ... }:
{
  options = {
    system-modules.blockdoth.enable = lib.mkEnableOption "enables user blockdoth";
  };

  config = lib.mkIf config.system-modules.blockdoth.enable{
    security.sudo.wheelNeedsPassword = false;
    users.users.blockdoth = {
      isNormalUser = true;
      shell = pkgs.fish;
      extraGroups = [ "wheel" "networkmanager" "audio"];
    };
  };
}