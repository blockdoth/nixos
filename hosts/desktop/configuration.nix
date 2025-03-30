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
    core.networking.hostname = "desktop";
    presets = {
      gui.enable = true;
      gaming.enable = true;
    };
    common.syncthing.enable = true;
    services = {
      observability.gatus.enable = true;
    };
  };

  system-modules.services.observability.gatus.endpoints = [
    {
      name = "test";
      url = "https://www.google.com";
      interval = "30s";
      conditions = [
        "[STATUS] == 200"
        "[RESPONSE_TIME] < 500"
      ];
    }
  ];
  networking.hostName = "desktop";
  system.stateVersion = "24.05"; # Did you read the comment?
}
