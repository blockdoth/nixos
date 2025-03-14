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
    users.penger.enable = true;
    core.networking.hostname = "nuc";
    presets = {
      mediaserver.enable = true;
      iss-piss-stream.enable = true;
    };
    common = {
      syncthing.enable = true;
      docker.enable = true;
    };
    core.tailscale.exit-node = true;

    services = {
      network = {
        acme.enable = true;
        ddns.enable = true;
        caddy.enable = true;
        headscale.enable = true;
        blocky.enable = false;
      };
      # auth = {
      #   authelia.enable = true;
      #   lldap.enable = true;
      # };

      gameservers = {
        minecraft.enable = true;
      };
      observability = {
        gatus.enable = false;
      };
      web = {
        immich.enable = true;
        nextcloud.enable = false;
      };
      sync = {
        atuin.enable = true;
        anki.enable = false;
      };
    };
  };

  system.stateVersion = "24.05"; # Did you read the comment?
}
