{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ../../system-modules/options.nix
    ./hardware.nix
  ];

  system-modules = {
    users.blockdoth.enable = true;
    core.networking.hostname = "laptop";
    presets = {
      gui.enable = true;
      laptop.enable = true;
    };
    common = {
      syncthing.enable = true;
      trackpad.enable = true;
    };
    services = {
      # observability.gatus.enable = true;

      network = {
        caddy.enable = true;

      };
    };
  };
  services.caddy = {
    virtualHosts."jupyter.insinuatis.com".extraConfig = ''
      reverse_proxy 127.0.0.1:8890        
    '';
  };

  system.stateVersion = "24.05"; # Did you read the comment?
}
