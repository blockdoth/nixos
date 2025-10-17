{
  config,
  lib,
  inputs,
  ...
}:
let
  enableGui = config.system-modules.presets.gui.enable;
  enableGaming = config.system-modules.presets.gaming.enable;
  enableLaptop = config.system-modules.presets.laptop.enable;
  enableServer = config.system-modules.presets.server.enable;
  enableMediaServer = config.system-modules.presets.mediaserver.enable;
  enablePissStream = config.system-modules.presets.iss-piss-stream.enable;
  enableUserPenger = config.system-modules.users.penger.enable;
  enableUserBlockdoth = config.system-modules.users.blockdoth.enable;
  secrets = inputs.nixos-secrets;
  inherit (lib)
    mkEnableOption
    mkDefault
    mkOption
    types
    ;
in
{
  imports = [
    ./core
    ./common
    ./display
    ./services
    ../../users/blockdoth/system.nix
    ../../users/penger/system.nix
  ];

  options = {
    system-modules = {
      presets = {
        defaults.enable = mkEnableOption "core configuration";
        gui.enable = mkEnableOption "graphical interface";
        gaming.enable = mkEnableOption "gaming";
        laptop.enable = mkEnableOption "laptop specific config";
        server.enable = mkEnableOption "server specific config";
        mediaserver.enable = mkEnableOption "mediaserver";
        iss-piss-stream.enable = mkEnableOption "piss stream observability";
        zenmode.enable = mkEnableOption "zenmode";
      };

      secrets = {
        domains = {
          homelab = mkOption {
            type = types.str;
            default = "127.0.0.1";
          };
          public = mkOption {
            type = types.str;
            default = "127.0.0.1";
          };
          personal = mkOption {
            type = types.str;
            default = "127.0.0.1";
          };
        };
        mails = {
          uni = mkOption { type = types.str; };
          personal = mkOption { type = types.str; };
        };
      };

      users = {
        blockdoth.enable = mkEnableOption "user blockdoth";
        penger.enable = mkEnableOption "user penger";
      };

      core = {
        grub.enable = mkEnableOption "grub";
        env.enable = mkEnableOption "env";
        networking = {
          enable = mkEnableOption "networking config";
          hostname = mkOption { type = types.str; };
          wakeOnLan = mkEnableOption "wake on lan";
        };
        impermanence.enable = mkEnableOption "impermanence";
        localization.enable = mkEnableOption "localization settings";
        nix-config.enable = mkEnableOption "nix config";
        secrets.enable = mkEnableOption "secrets management";
        ssh.enable = mkEnableOption "ssh";
        tailscale = {
          enable = mkEnableOption "tailscale";
          exit-node = mkEnableOption "can serve as exitnode";
        };
        syncthing.enable = mkEnableOption "syncthing";
      };

      common = {
        audio.enable = mkEnableOption "audio";
        bluetooth.enable = mkEnableOption "bluetooth";
        crosscompilation.enable = mkEnableOption "cross-compilation";
        docker.enable = mkEnableOption "docker";
        gaming.enable = mkEnableOption "gaming";
        powerprofile = mkOption {
          type = types.str;
        };
        printing.enable = mkEnableOption "printing";
        trackpad.enable = mkEnableOption "trackpad";
        wireshark.enable = mkEnableOption "wireshark";
        filemanager.enable = mkEnableOption "filemanager";
        plymouth.enable = mkEnableOption "plymouth";
        udev.enable = mkEnableOption "udev";
        nfs = {
          client = {
            enable = mkEnableOption "nfs client";
            mounts = types.listOf (
              types.submodule {
                options = {
                  address = mkOption { type = types.str; };
                  name = mkOption { type = types.str; };
                };
              }
            );
          };
          server = {
            enable = mkEnableOption "nfs server";
            exports = types.listOf (types.str);
          };
        };
      };

      display = {
        autologin.enable = mkEnableOption "autologin";
        wayland.enable = mkEnableOption "hyprland";
        x11.enable = mkEnableOption "x11";
      };

      services = {
        servers = {
          minecraft.enable = mkEnableOption "minecraft server";
          factorio.enable = mkEnableOption "factorio server";
          chatger.enable = mkEnableOption "chatger";
          chatger-registry.enable = mkEnableOption "chatger-registry";
        };
        network = {
          ddns.enable = mkEnableOption "ddns";
          acme.enable = mkEnableOption "acme";
          blocky.enable = mkEnableOption "blocky";
          headscale.enable = mkEnableOption "headscale";
          fail2ban.enable = mkEnableOption "fail2ban";
          pihole.enable = mkEnableOption "pihole";
          reverse-proxy = {
            nginx = {
              enable = mkEnableOption "nginx";
            };
            caddy = {
              enable = mkEnableOption "caddy";
            };
            proxies = mkOption {
              type = types.listOf (
                types.submodule {
                  options = {
                    subdomain = mkOption { type = types.str; };
                    domain = mkOption {
                      type = types.str;
                      default = config.system-modules.secrets.domains.homelab;
                    };
                    port = mkOption {
                      type = types.int;
                    };
                    require-auth = mkOption {
                      type = types.bool;
                      default = false;
                    };
                    redirect-address = mkOption {
                      type = types.str;
                      default = "127.0.0.1";
                    };
                    extra-config = mkOption {
                      type = types.str;
                      default = "";
                    };
                  };
                }
              );
              default = [ ];
            };
          };
        };
        auth = {
          authelia = {
            enable = mkEnableOption "authelia";
            port = mkOption { type = types.int; };
          };
          lldap = {
            enable = mkEnableOption "lldap";
            shared-group = mkOption { type = types.str; };
            shared-jwt = mkOption { type = types.str; };
            shared-password = mkOption { type = types.str; };
          };
        };

        observability = {
          grafana.enable = mkEnableOption "grafana";
          loki.enable = mkEnableOption "loki";
          prometheus.enable = mkEnableOption "prometheus";
          promtail.enable = mkEnableOption "promtail";
          gatus.enable = mkEnableOption "gatus";
          metabase.enable = mkEnableOption "metabase";
          healthchecks.endpoints = mkOption {
            type = types.listOf (
              types.submodule {
                options = {
                  name = mkOption { type = types.str; };
                  url = mkOption { type = types.str; };
                  endpoint = mkOption {
                    type = types.str;
                    default = "";
                  };
                  interval = mkOption {
                    type = types.str;
                    default = "30s";
                  };
                  conditions = mkOption {
                    type = types.listOf types.str;
                    default = [
                      "[STATUS] == 200"
                      "[RESPONSE_TIME] < 500"
                    ];
                  };
                };
              }
            );
            default = [ ];
          };
        };

        scraping = {
          iss-piss-stream.enable = mkEnableOption "iss piss stream monitoring";
          connectbox.enable = mkEnableOption "connect box prometheus exporter";
        };

        sync = {
          atuin.enable = mkEnableOption "atuin shell sync";
          anki.enable = mkEnableOption "anki";
        };

        media = {
          audiobookshelf.enable = mkEnableOption "audiobookshelf";
          bazarr.enable = mkEnableOption "bazarr";
          jellyfin.enable = mkEnableOption "jellyfin";
          jellyseerr.enable = mkEnableOption "jellyseer";
          prowlarr.enable = mkEnableOption "prowlarr";
          radarr.enable = mkEnableOption "radarr";
          lidarr.enable = mkEnableOption "lidarr";
          sonarr.enable = mkEnableOption "sonarr";
          transmission.enable = mkEnableOption "transmission";

          # This module is heavily inspired by https://github.com/zmitchell/nixos-configs/blob/main/modules/media_server.nix
          mediaDir = mkOption {
            type = types.str;
            default = "/var/lib/media";
            description = "Directory for media storage";
          };
          group = mkOption {
            type = types.str;
            default = "media";
            description = "Group for media access";
          };
        };
        vaultwarden.enable = mkEnableOption "vaultwarden";
        filebrowser.enable = mkEnableOption "filebrowser";
        immich.enable = mkEnableOption "immich";
        linkwarden.enable = mkEnableOption "linkwarden";
        nextcloud.enable = mkEnableOption "nextcloud";
        homepage.enable = mkEnableOption "homepage";
        microbin.enable = mkEnableOption "microbin";
        httpbin.enable = mkEnableOption "httpbin";
        githubrunners.enable = mkEnableOption "github runners";
      };
    };
  };
  config = {
    system-modules = {
      secrets = {
        domains = {
          homelab = secrets.domains.homelab;
          public = secrets.domains.public;
          personal = secrets.domains.personal;
        };
        mails = {
          uni = secrets.mails.uni;
          personal = secrets.mails.personal;
        };
      };
      core = {
        grub.enable = mkDefault true;
        env.enable = mkDefault true;
        networking.enable = mkDefault true;
        localization.enable = mkDefault true;
        nix-config.enable = mkDefault true;
        secrets.enable = mkDefault true;
        ssh.enable = mkDefault true;
        tailscale = {
          enable = mkDefault true;
          exit-node = mkDefault false;
        };
        syncthing.enable = mkDefault true;
      };

      common = {
        audio.enable = mkDefault enableGui;
        bluetooth.enable = mkDefault enableLaptop;
        trackpad.enable = mkDefault enableLaptop;
        gaming.enable = mkDefault enableGaming;
        powerprofile =
          if enableLaptop then
            "laptop"
          else if enableServer then
            "server"
          else
            "nvt";
      };

      display = {
        autologin.enable = mkDefault enableGui;
        wayland.enable = mkDefault enableGui;
        x11.enable = mkDefault false;
      };

      services = {
        observability = {
          grafana.enable = mkDefault enablePissStream;
          loki.enable = mkDefault enablePissStream;
          prometheus.enable = mkDefault enablePissStream;
          promtail.enable = mkDefault enablePissStream;
        };
        scraping = {
          iss-piss-stream.enable = mkDefault enablePissStream;
        };

        media = {
          bazarr.enable = mkDefault enableMediaServer;
          jellyfin.enable = mkDefault enableMediaServer;
          prowlarr.enable = mkDefault enableMediaServer;
          radarr.enable = mkDefault enableMediaServer;
          lidarr.enable = mkDefault enableMediaServer;
          sonarr.enable = mkDefault enableMediaServer;
          transmission.enable = mkDefault enableMediaServer;
        };
      };
    };

    # Prevent me from fucking myself over again
    assertions = [
      {
        assertion = enableUserPenger || enableUserBlockdoth;
        message = "At least one user must be enabled";
      }
      {
        assertion = enableGui || !(enableGui && enableGaming);
        message = "To use the gaming module, the gui module must be enabled";
      }
    ];
  };
}
