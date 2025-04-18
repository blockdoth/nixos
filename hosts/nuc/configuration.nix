{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ../../modules/system/options.nix
    ./hardware.nix
  ];

  system-modules = {
    users.penger.enable = true;
    core = {
      networking.hostname = "nuc";
      tailscale.exit-node = true;
    };

    presets = {
      # mediaserver.enable = true;
      iss-piss-stream.enable = true;
    };
    common = {
      syncthing.enable = true;
      docker.enable = true;
    };

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
        gatus.enable = true;
      };

      sync = {
        atuin.enable = true;
        anki.enable = true;
      };

      immich.enable = true;
      vaultwarden.enable = true;
      nextcloud.enable = false;
      linkwarden.enable = true;
    };
  };

  system.stateVersion = "24.05"; # Did you read the comment?
}
