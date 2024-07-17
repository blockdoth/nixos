{ inputs, config, pkgs, lib, ... }:
{
  imports = [
    ./hardware.nix 
    ../../system-modules/bundle.nix
  ];

  stylix.enable = true;
  stylix.base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/everforest.yaml";

  system-modules = {
    common.enable = true;
    gui.enable = true;
    sound.enable = true;
    bluetooth.enable = true;
    battery.enable = true;
    users.headless.enable = true;
  };

  networking = {
    firewall = {
      firewall.enable = true;
      allowedTCPPorts = [ 80 443 22 ];
    };
  };
  
  system.stateVersion = "24.05"; # Did you read the comment?
}
