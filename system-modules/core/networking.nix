{ config, lib, ... }:
let
  module = config.system-modules.core.networking;
  hostname = module.hostname;
in
{
  config = lib.mkIf module.enable {
    networking = {
      hostName = hostname;
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
