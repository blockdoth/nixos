{config, lib, ... }:
{
  options = {
    networking.enable = lib.mkEnableOption "Enables networking";
  };

  config = lib.mkIf config.networking.enable {
    networking = {
      networkmanager = {
        enable = true;
        wifi.scanRandMacAddress = false;
      };
      wireless = {
        enable = true;
        userControlled.enable = true;
        networks = {
          eduroam = {
            auth = ''
              key_mgmt=WPA-EAP
              eap=PWD
              identity="povanegmond@tudelf.nl"
              password="${builtins.readFile ../../secrets/eduroam}"
              '';
          };
        };
      };
    };
  };
}