{config, lib, ... }:
{
  options = {
    system-modules.networking.enable = lib.mkEnableOption "Enables networking";
  };

  config = lib.mkIf config.system-modules.networking.enable {
    networking = {
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