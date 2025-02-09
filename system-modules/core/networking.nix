{ config, lib, ... }:
{
  options = {
    system-modules.common.networking.enable = lib.mkEnableOption "Enables networking";
  };

  config = lib.mkIf config.system-modules.common.networking.enable {
    networking = {
      firewall = {
        enable = true;
      };
      networkmanager = {
        enable = true;
        wifi.scanRandMacAddress = false;
      };
      # wireless = {
      #   enable = false;
      #   userControlled.enable = true;
      #   networks = {
      #     eduroam = {
      #       auth = ''
      #         key_mgmt=WPA-EAP
      #         eap=PWD
      #         identity="povanegmond@tudelf.nl"
      #         password="${builtins.readFile ../../secrets/eduroam}"
      #         '';
      #     };
      #   };
      # };
    };
  };
}
