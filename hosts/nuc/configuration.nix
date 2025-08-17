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
      mediaserver.enable = true;
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
        headscale.enable = true;
        fail2ban.enable = true;
        reverse-proxy = {
          caddy.enable = true;
        };
      };
      auth = {
        authelia.enable = true;
        lldap.enable = true;
      };
      servers = {
        minecraft.enable = true;
        chatger.enable = true;
      };
      observability = {
        gatus.enable = true;
      };

      sync = {
        atuin.enable = true;
        anki.enable = true;
      };

      media = {
        audiobookshelf.enable = true;
        jellyseerr.enable = true;
      };
      immich.enable = true;
      vaultwarden.enable = true;
      linkwarden.enable = false;
      nextcloud.enable = false;
      microbin.enable = false;
      homepage.enable = true;
      httpbin.enable = true;
    };
  };

  system.stateVersion = "24.05"; # Did you read the comment?
}
